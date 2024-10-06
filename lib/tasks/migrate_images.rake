# lib/tasks/migrate_images_to_s3.rake
require "open-uri"
require "aws-sdk-s3"
require "securerandom"

namespace :images do
  desc "Migrate image strings to AWS S3 with progress tracking and error handling"
  task migrate_to_s3: :environment do
    class ImageMigrator
      def initialize
        @success_count = 0
        @error_count = 0
        @processed_count = 0
      end

      def migrate_model(model_class)
        total_records = model_class.where.not(image: [nil, ""]).count
        puts "Starting migration for #{model_class.name}. Total records: #{total_records}"

        model_class.where.not(image: [nil, ""]).find_each.with_index do |record, index|
          begin
            migrate_record(record)
            print_progress(index + 1, total_records)
          rescue => e
            log_error(record, e)
          end
        end

        print_summary(model_class)
      end

      private

      def migrate_record(record)
        return if record.image.attached? || !valid_image_url?(record.image)

        image_url = record.image
        downloaded_image = URI.open(image_url)
        filename = extract_filename(image_url)

        ActiveRecord::Base.transaction do
          # Store original URL before attaching new image
          record.update_column(:original_image_url, image_url) if record.respond_to?(:original_image_url)

          # Attach image to record
          record.image.attach(
            io: downloaded_image,
            filename: filename,
            content_type: downloaded_image.content_type || "image/jpeg",
          )

          # Clear old image string if attachment is successful
          record.update_column(:image, nil) if record.image.attached?

          @success_count += 1
        end
      rescue StandardError => e
        @error_count += 1
        raise e
      ensure
        @processed_count += 1
        downloaded_image&.close if downloaded_image.respond_to?(:close)
      end

      def valid_image_url?(url)
        uri = URI.parse(url)
        uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      rescue URI::InvalidURIError
        false
      end

      def extract_filename(url)
        uri = URI.parse(url)
        File.basename(uri.path).presence || "image_#{SecureRandom.hex(8)}"
      rescue URI::InvalidURIError
        "image_#{SecureRandom.hex(8)}"
      end

      def print_progress(current, total)
        progress = (current.to_f / total * 100).round(2)
        print "\rProgress: #{progress}% (#{current}/#{total}) | Success: #{@success_count} | Errors: #{@error_count}"
      end

      def log_error(record, error)
        error_message = "Error migrating #{record.class.name} ID: #{record.id} - #{error.message}"
        Rails.logger.error(error_message)
        puts "\n#{error_message}"
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
    migrator = ImageMigrator.new

    puts "Starting image migration to AWS S3..."
    puts "Backup your database if you haven't already!"
    puts "Press Enter to continue or Ctrl+C to abort..."
    STDIN.gets

    # Add a backup column if it doesn't exist
    unless Listing.column_names.include?("original_image_url")
      puts "Adding backup column for original URLs..."
      ActiveRecord::Base.connection.add_column :listings, :original_image_url, :string
    end

    unless Offer.column_names.include?("original_image_url")
      ActiveRecord::Base.connection.add_column :offers, :original_image_url, :string
    end

    # Migrate each model
    migrator.migrate_model(Listing)
    migrator.migrate_model(Offer)

    puts "\nMigration completed!"
  end
end
