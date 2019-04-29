CREATE TABLE Calendar(date DATE,
                      PRIMARY KEY (date));

CREATE TABLE available_at(id INTEGER,
                          date DATE,
                          price FLOAT,
                          available CHAR(1), 
                          PRIMARY KEY (id,date),
                          FOREIGN KEY (date) REFERENCES Calendar(date),
                          FOREIGN KEY (id) REFERENCES Listing(id) )  ;

CREATE TABLE Accommodation(accommodates INTEGER,
                          PRIMARY KEY (accomodates) ) ;

CREATE TABLE Bedding(beds INTEGER,
                     bed_type CHAR(32),
                     PRIMARY KEY (beds,bed_type) );

CREATE TABLE Bathrooms(bathrooms FLOAT,
                      PRIMARY KEY (bathrooms) );

CREATE TABLE Bedrooms(bedrooms INTEGER,
                      PRIMARY KEY(bedrooms) );

CREATE TABLE Room(room_type CHAR(32),
                  PRIMARY KEY(room_type) );

CREATE TABLE Property(property_type CHAR(32),
                      PRIMARY KEY (property_type) );

CREATE TABLE Amenities(amenities CHAR(32),
                       PRIMARY KEY (amenities) );
                       
CREATE TABLE Provides(id INTEGER,
                    amenities CHAR(32),
                    PRIMARY KEY (id,amenities),
                    FOREIGN KEY (amenities) REFERENCES Amenities(amenities),
                    FOREIGN KEY (id) REFERENCES Listing(id) ) ;

CREATE TABLE Policy(cancellation_policy CHAR(32),
                    PRIMARY KEY (cancellation_policy) );

CREATE TABLE Described_Description(description_id INTEGER AUTO_INCREMENT,
                                   summary VARCHAR(1024),
                                   space VARCHAR(1024),
                                   description VARCHAR(1024),
                                   neighbourhood_overview VARCHAR(1024),
                                   notes VARCHAR(1024),
                                   transit VARCHAR(1024),
                                   access VARCHAR(1024),
                                   picture_URL CHAR(32),
                                   square_feet FLOAT,
                                   id INTEGER NOT NULL,
                                   PRIMARY KEY (description_id,id),
                                   FOREIGN KEY (id) REFERENCES Listing(id)
                                   ON DELETE CASCADE) ;
         
CREATE TABLE Score (review_scores_rating INTEGER,        
                    review_score_accuracy INTEGER,
                    review_scores_cleanliness INTEGER,
                    review_scores_checkin INTEGER,
                    review_scores_communication INTEGER,
                    review_scores_location INTEGER,
                    review_scores_value INTEGER,
                    id INTEGER, 
                    PRIMARY KEY(id),
                    FOREIGN KEY (id) REFERENCES Listing(id) ON DELETE CASCADE ) ;
                   

CREATE TABLE Reviewer(reviewer_id INTEGER,
                      reviewer_name CHAR(32),
                      PRIMARY KEY (reviewer_id) )

CREATE TABLE Review (review_id INTEGER AUTO_INCREMENT,
					 review_date DATE,                     
                     comments VARCHAR(1024),
					 PRIMARY key(review_id) ) 
					 
CREATE TABLE Reviewed(id INTEGER,
                     reviewer_id INTEGER,                     
                     review_id INTEGER,
                     PRIMARY KEY(id, review_id, reviewer_id),
                     FOREIGN KEY (id) REFERENCES Listing(id),
                     FOREIGN KEY (reviewer_id) REFERENCES Reviewer(reviewer_id),
					 FOREIGN KEY (review_id) REFERENCES Review(review_id) )
                     
CREATE TABLE Host(host_id INTEGER, 
                  host_since DATE,
                  host_about VARCHAR(1024),
                  host_response_time FLOAT,
                  host_response_rate FLOAT, 
                  host_neighborhood CHAR(32) NOT NULL,
				          host_country_code INTEGER NOT NULL,
				          host_city CHAR(32) NOT NULL,
                  PRIMARY KEY(host_id),
                  FOREIGN KEY (host_country_code,host_city,host_neighborhood) REFERENCES Neighbourhood(country_code,city,neighbourhood) )
				  
CREATE TABLE Verification(host_verifications CHAR(32),
                          PRIMARY KEY (host_verifications) );
                         
CREATE TABLE Verified_by(host_id INTEGER,
                         host_verifications CHAR(32),
                         PRIMARY KEY (host_id,host_verifications),
                         FOREIGN KEY (host_id) REFERENCES Host(host_id),
                         FOREIGN KEY (host_verifications) REFERENCES Verification(host_verifications) );

CREATE TABLE Pricing(price FLOAT, 
                     weekly_price FLOAT, 
                     monthly_price FLOAT,
                     security_deposit FLOAT,
                     cleaning_fee FLOAT,
                     guests_included INTEGER,
                     extra_people FLOAT,
                     minimum_nights INTEGER,
                     maximum_nighs INTEGER,
                     id INTEGER NOT NULL,
                     PRIMARY KEY(price,id),
                     FOREIGN KEY (id) REFERENCES Listing(id) ON DELETE CASCADE ) ;
 
CREATE TABLE Country(country_code CHAR(2),
                     country CHAR(32),
                     PRIMARY KEY (country_code) ) ;

CREATE TABLE City(city CHAR(32),
                  country_code CHAR(2),
                  PRIMARY KEY (country_code,city), 
                  FOREIGN KEY (country_code) REFERENCES Country(country_code) );

CREATE TABLE Neighbourhood(neighbourhood CHAR(32), 
                           city CHAR(32),
                           country_code CHAR(2),
                           PRIMARY KEY (country_code,city,neighbourhood),
                           FOREIGN KEY (country_code) REFERENCES Country(country_code),
                           FOREIGN KEY (city) REFERENCES City(city) );
                         
CREATE TABLE Listing(id INTEGER,
                     listing_url CHAR(32),
                     name CHAR(32),
                     accommodates CHAR(32) NOT NULL,
                     cancellation_policy CHAR(32) NOT NULL,
                     host_id INTEGER NOT NULL,
                     host_name CHAR(32),
                     neighbourhood CHAR(32) NOT NULL,
					           city CHAR(32) NOT NULL,
					           country_code CHAR(2) NOT NULL,
                     latitude FLOAT,
                     longitude FLOAT,
                     property_type CHAR(32) NOT NULL,
                     room_type CHAR(32) NOT NULL,
                     bathrooms FLOAT NOT NULL,
                     bedrooms INTEGER NOT NULL, 
                     beds INTEGER NOT NULL,
                     bed_type CHAR(32) NOT NULL,
					           interaction VARCHAR(1024),
					           house_rules VARCHAR(1024),
					           is_business_travel_ready CHAR(1),
					           require_guest_profile_picture CHAR(1),
					           require_guest_phone_verification CHAR(1),
                     PRIMARY KEY (id),
                     FOREIGN KEY (property_type) REFERENCES Property(property_type),
                     FOREIGN KEY (room_type) REFERENCES Room(room_type),
                     FOREIGN KEY (accommodates) REFERENCES Accommodation(accommodates),
                     FOREIGN KEY (bathrooms) REFERENCES Bathrooms(bathrooms),
                     FOREIGN KEY (bedrooms) REFERENCES Bedrooms(bedrooms),
                     FOREIGN KEY (beds,bed_type) REFERENCES Bedding(beds,bed_type),
                     FOREIGN KEY (cancellation_policy) REFERENCES Policy(cancellation_policy),
                     FOREIGN KEY (host_id) REFERENCES Host(host_id),
                     FOREIGN KEY (country_code,city,neighbourhood) REFERENCES Neighbourhood(country_code,city,neighbourhood),
					           FOREIGN KEY (country_code,city) REFERENCES City(country_code,city),
					           FOREIGN KEy (country_code) REFERENCES Country(country_code),
					           FOREIGN KEY (cancellation_policy) REFERENCES Policy(cancellation_policy) );
