# Muse MVP Specification

An app designed for the customer by the customer. 

Muse is a customer driven app that prioritizes the customer's needs by bringing the seller to the buyer. Instead of looking through countless listings only to not find what you’re looking for; you create a listing containing the item you want and the sellers, merchants, and retailers offer you the product. Additionally, we offer a social media-esque platform to help you curate your perfect shopping list; allowing you to organize what you’re looking for in aesthetically pleasing categories and giving your posts more visibility. 

## Pain Point 
Just as users spend countless hours scrolling through various social media platforms. Online shoppers also spend a copious  amount of time scrolling through listings only to come away with absolutely nothing. To fix that, customers create the product listings because they know exactly what they want best.

## User Stories 

### Buyer Stories
- As a customer, I want to register for a buyer account to post a listing for the item(s) I'm looking for.
- As a customer, I want to log in to access my personal account and create listings for the item(s) I'm looking for. 
- As a customer, I want to edit the information contained in the listings. 
- As a customer, I want to delete listings that are no longer relevant.
- As a customer, I want to respond to potential offers and messages from sellers. 


### Seller stories
- As a retailer, I want to register for a seller account to make offers to potential customers.
- As a retailer, I want to log in to access my personal account and send messages to potential customers.
- As a retailer, I want to send private offers to potential customers.

### Buyer and Seller Stories
- As a user, I want to use a platform that's designed for and prioritizes the customer's needs.
- As a user, I want to receive email and/or SMS notifications whenever a seller or buyer messages me.
- As a user, I want to update my profile and personal information. 


## Domain Model

### Users 
- id 
- name
- email
- password
- username
- address
- image 
- bio
- location
- seller_id
- account_type

### Messages
- id 
- sender_id
- recipient_id
- listing_id
- body

### Listings
- id
- image
- caption
- category_id
- buyer_id
- purchased

### Offers
- id
- seller_id
- image 
- description
- listing_id
- price
- message_id

### Categories
- id 
- name
