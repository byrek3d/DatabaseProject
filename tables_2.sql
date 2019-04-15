CREATE TABLE Calendar(cal_id CHAR(32),
                      date DATE, 
                      PRIMARY KEY (cal_id))

CREATE TABLE available_at(id CHAR(32),
                          cal_id CHAR(32),
                          price FLOAT,
                          available CHAR(1), 
                          PRIMARY KEY (id,cal_id),
                          FOREIGN KEY (cal_id) REFERENCES Calendar(cal_id),
                          FOREIGN KEY (id) REFERENCES Listing(id) 
                          /*can't ensure participation constraint*/) 

CREATE TABLE Accomodation(accomodates CHAR(32),
                          PRIMARY KEY (accomodates) )

CREATE TABLE Bedding(beds INTEGER,
                     bed_type CHAR(32),
                     PRIMARY KEY (beds,bed_type) )

CREATE TABLE Bathrooms(bathrooms INTEGER,
                      PRIMARY KEY (bathrooms) )

CREATE TABLE Bedrooms(bedrooms INTEGER,
                      PRIMARY KEY(bedrooms) )

CREATE TABLE Room(room_type CHAR(32),
                  PRIMARY KEY(room_type) )

CREATE TABLE Property(property_type CHAR(32),
                      PRIMARY KEY (property_type) )

CREATE TABLE Amenities(amenities_id CHAR(32),
                       amenities CHAR(32))
                       
CREATE TABLE Provide(id CHAR(32),
                    amenities_id CHAR(32),
                    PRIMARY KEY (id,amenities_id),
                    FOREIGN KEY (amenities_id) REFERENCES Amenities(amenities_id),
                    FOREIGN KEY (id) REFERENCES Listing(id) )                 

CREATE TABLE Policy(policy_id CHAR(32),
                    is_buisness_travel_ready CHAR(1),
                    cancellation_policy CHAR(32),
                    require_guest_profile_picture CHAR(1),
                    require_guest_phone_verification CHAR(1)
                    PRIMARY KEY (policy_id) )

CREATE TABLE Described_Description(description_id CHAR(32),
                                   summary VARCHAR(1024),
                                   space VARCHAR(1024),
                                   description VARCHAR(1024),
                                   neighborhood_overview VARCHAR(1024),
                                   notes VARCHAR(1024),
                                   transit VARCHAR(1024),
                                   access VARCHAR(1024),
                                   picture URL CHAR(32),
                                   square_feet FLOAT,
                                   id CHAR(32) NOT NULL
                                   PRIMARY KEY (description_id,id)
                                   FOREIGN KEY (id) REFERENCES Listing(id)
                                   ON DELETE CASCADE) ) 
         
CREATE TABLE Score (review_scores_rating INTEGER,        
                    review_score_accuracy INTEGER,
                    review_scores_cleanliness INTEGER,
                    review_scores_checkin INTEGER,
                    review_scores_communication INTEGER,
                    review_scores_location INTEGER,
                    review_scores_value INTEGER,
                    id CHAR (32), 
                    PRIMARY KEY(id),
                    FOREIGN KEY (id) REFERENCES Listing(id) ON DELETE CASCADE )  
                    /*how to ensure weak entity + one to one */

CREATE TABLE Reviewer(reviewer_id CHAR(32),
                      reviewer_name CHAR(32)
                      PRIMARY KEY (reviewer_id) )

CREATE TABLE reviewed(id CHAR(32),
                     reviewer_id CHAR(32),                     
                     comments VARCHAR(1024),
                     review_date DATE,
                     PRIMARY KEY(id, review_date),
                     FOREIGN KEY (id) REFERENCES Listing(id),
                     FOREIGN KEY (reviewer_id) REFERENCES Reviewer(reviewer_id) )
                     
CREATE TABLE Host(host_id CHAR(32), 
                  host_since DATE,
                  host_about VARCHAR(1024),
                  host_response_time FLOAT,
                  host_response_rate FLOAT, 
                  host_neighborhood CHAR(32) NOT NULL,
                  PRIMARY KEY(host_id)
                  FOREIGN KEY (host_neighborhood) REFERENCES Neighborhood(neighborhood))

CREATE TABLE Verification(host_verifications_id CHAR(32),
                          host_verifications CHAR(32),
                          PRIMARY KEY (host_verifications_id) )
                         
CREATE TABLE Verified_by(host_id CHAR(32),
                         host_verifications_id CHAR(32),
                         PRIMARY KEY (host_id,host_verifications_id),
                         FOREIGN KEY (host_id) REFERENCES Host(host_id),
                         FOREIGN KEY (host_verifications_id) REFERENCES 
                         Verification(host_verifications_id) )

CREATE TABLE Pricing(price FLOAT, 
                     weekly_price FLOAT, 
                     monthly_price FLOAT,
                     security_deposit FLOAT,
                     cleaning_fee FLOAT,
                     guests_included INTEGER,
                     extra_people FLOAT,
                     minimum_nights INTEGER,
                     maximum_nighs INTEGER,
                     id CHAR(32) NOT NULL,
                     PRIMARY KEY(price,id),
                     FOREIGN KEY (id) REFERENCES Listing(id) ON DELETE CASCADE )
 
CREATE TABLE Country(country_code CHAR(32),
                     country CHAR(32),
                     PRIMARY KEY (country_code) )

CREATE TABLE City(city CHAR(32),
                  country_code CHAR(32),
                  PRIMARY KEY (country_code,city), 
                  FOREIGN KEY (country_code) REFERENCES Country(country_code) )

CREATE TABLE Neighborhood(neighborhood CHAR(32), 
                           city CHAR(32),
                           country_code CHAR(32),
                           PRIMARY KEY (country_code,city,neighborhood),
                           FOREIGN KEY (country_code) REFERENCES Country(country_code),
                           FOREIGN KEY (city) REFERENCES City(city) )
                         
CREATE TABLE Listing(id CHAR(32),
                     lisitng_url CHAR(32),
                     name CHAR(32),
                     acc_id CHAR(32) NOT NULL,
                     policy_id CHAR(32) NOT NULL,
                     host_id CHAR(32) NOT NULL,
                     host_url CHAR(32),
                     host_name CHAR(32),
                     host_thumbnail_url CHAR(32),
                     host_picture_ur CHAR(32),
                     neighborhood CHAR(32) NOT NULL,
                     latitude FLOAT,
                     longitude FLOAT,
                     property_type CHAR(32) NOT NULL,
                     room_type CHAR(32) NOT NULL,
                     accomodates CHAR(32),
                     bathrooms INTEGER NOT NULL,
                     bedrooms INTEGER NOT NULL, 
                     beds INTEGER NOT NULL,
                     bed_type CHAR(32) NOT NULL,
                     PRIMARY KEY (id),
                     FOREIGN KEY (property_type) REFERENCES Property(property_type),
                     FOREIGN KEY (room_type) REFERENCES Room(room_type),
                     FOREIGN KEY (accomodates) REFERENCES Accomodation(accomodates),
                     FOREIGN KEY (bathrooms) REFERENCES Bathrooms(bathrooms),
                     FOREIGN KEY (bedrooms) REFERENCES Bedrooms(bedrooms),
                     FOREIGN KEY (beds,bed_type) REFERENCES Bedding(beds,bed_type),
                     FOREIGN KEY (acc_id) REFERENCES Accomodation(acc_id), 
                     FOREIGN KEY (policy_id) REFERENCES Policy(policy_id),
                     FOREIGN KEY (host_id) REFERENCES Host(host_id),
                     FOREIGN KEY (neighborhood) REFERENCES Neighborhood(neighborhood) )