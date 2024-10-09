# lib/tasks/migrate_images_to_s3.rake
require 'open-uri'
require 'aws-sdk-s3'

namespace :images do
  desc 'Migrate image strings to AWS S3 with ActiveStorage handling'
  task migrate_to_s3: :environment do
    class ImageMigrator
      def initialize
        @success_count = 0
        @error_count = 0
        @processed_count = 0
      end

      def migrate_model(model_class)
        puts "\nStarting migration for #{model_class.name}"

        # Get total records count directly
        total_records = model_class.unscoped.where.not(image: [nil, '']).count
        puts "Found #{total_records} records to process"

        records = model_class.unscoped.where.not(image: [nil, '']).select('id, image')
        records.find_each do |record|
          begin
            # Debug: Print record details
            puts "\nProcessing record ID: #{record.id}"
            puts "Raw image value: #{record.read_attribute(:image)}"

            process_record(record, model_class)
            print_progress(@processed_count, total_records)
          rescue => e
            log_error(record, e)
          end
        end

        print_summary(model_class)
      end

      private

      def process_record(record, model_class)
        # Get the full record with all associations
        full_record = model_class.find(record.id)

        # Skip if image is already attached
        if full_record.image.attached?
          puts "Image already attached for record #{record.id}"
          @processed_count += 1
          return
        end

        # Get the raw image URL from the database
        image_url = record.read_attribute(:image)

        if image_url.nil? || image_url.empty?
          puts "Skipping record #{record.id}: empty image value"
          @processed_count += 1
          return
        end

        puts "Processing URL: #{image_url}"

        begin
          download_and_attach(full_record, image_url)
          @success_count += 1
        rescue => e
          @error_count += 1
          raise e
        ensure
          @processed_count += 1
        end
      end

      def download_and_attach(record, url)
        puts "Downloading from URL: #{url}"

        downloaded_image = URI.open(url)
        filename = generate_filename(url)

        puts "Generated filename: #{filename}"

        ActiveRecord::Base.transaction do
          # Store original URL
          if record.respond_to?(:original_image_url)
            record.update_column(:original_image_url, url)
          end

          # Attach new image
          record.image.attach(
            io: downloaded_image,
            filename: filename,
            content_type: downloaded_image.content_type || 'image/jpeg'
          )

          # Clear old image URL if attachment successful
          if record.image.attached?
            record.update_column(:image, nil)
            puts "Successfully attached image for record #{record.id}"
          end
        end
      rescue OpenURI::HTTPError => e
        puts "HTTP Error downloading #{url}: #{e.message}"
        raise
      rescue => e
        puts "Error attaching image: #{e.message}"
        raise
      ensure
        downloaded_image&.close if downloaded_image.respond_to?(:close)
      end

      def generate_filename(url)
        return "image_#{SecureRandom.hex(8)}.jpg" if url.nil?

        begin
          base_name = File.basename(URI.parse(url).path)
          return "image_#{SecureRandom.hex(8)}.jpg" if base_name.blank?

          # Sanitize filename
          safe_name = base_name.gsub(/[^0-9A-Za-z.\-]/, '_')
          safe_name.include?('.') ? safe_name : "#{safe_name}.jpg"
        rescue
          "image_#{SecureRandom.hex(8)}.jpg"
        end
      end

      def log_error(record, error)
        message = "\nError processing #{record.class.name} ID: #{record.id}"
        message += "\nRaw image value: #{record.read_attribute(:image)}"
        message += "\nError: #{error.class.name}: #{error.message}"
        message += "\nBacktrace: #{error.backtrace[0..2].join("\n")}"

        puts message
        Rails.logger.error(message)
      end

      def print_progress(current, total)
        progress = (current.to_f / total * 100).round(2)
        print "\rProgress: #{progress}% (#{current}/#{total}) | Success: #{@success_count} | Errors: #{@error_count}"
      end

      def print_summary(model_class)
        puts "\n\n#{model_class.name} Migration Summary:"
        puts "Total Processed: #{@processed_count}"
        puts "Successful Migrations: #{@success_count}"
        puts "Failed Migrations: #{@error_count}"
        puts "-" * 50
      end
    end

    # Execute migration
    puts "Starting migration to AWS S3..."

    # First, let's check the database connection and tables
    begin
      puts "\nChecking database connection..."
      puts "Available tables: #{ActiveRecord::Base.connection.tables.join(', ')}"

      [Listing, Offer].each do |model|
        puts "\nChecking #{model.name} table..."
        puts "Record count: #{model.count}"
        puts "Records with images: #{model.unscoped.where.not(image: [nil, '']).count}"
      end
    rescue => e
      puts "Database check failed: #{e.message}"
      return
    end

    migrator = ImageMigrator.new

    # Add backup columns if they don't exist
    [Listing, Offer].each do |model|
      begin
        unless model.column_names.include?('original_image_url')
          puts "\nAdding original_image_url column to #{model.name}..."
          ActiveRecord::Base.connection.add_column model.table_name.to_sym, :original_image_url, :string
        end
      rescue => e
        puts "Warning: Could not add backup column to #{model.name}: #{e.message}"
      end
    end

    # Process each model
    [Listing, Offer].each do |model|
      begin
        migrator.migrate_model(model)
      rescue => e
        puts "\nFatal error processing #{model.name}: #{e.message}"
      end
    end

    puts "\nMigration completed!"
  end
end
