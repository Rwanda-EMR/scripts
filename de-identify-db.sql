-- De-identify database while preserving breadth and variability of data for reporting demonstration and testing
-- To better randomize the results of this script, make adjustments to the scramble function as needed.

-- ---------------------------------------
select "Updating Users...";
-- ---------------------------------------

-- update users set username = system_id where username is null and system_id is not null;

-- update users set
--  username = scramble(username),
--  system_id = scramble(username)
--where username not in ('admin', 'daemon', 'mseaton')
--;

--update users set
--  password = 'ffba0fa0e7638c1ed511d497cd24afc6a5bcf5231eb9661a87fe215201ba4ede020152a656f02f7ffa5ba34360fe4b0d1e237fe0efed8509fb087a1fadae437d',
--  salt = '0ce631e430099bfb05c83cbac134f4ace05a178f642b252517bc60be24eb4c3d4240b0f4421915c894eb9443e7e66f64dc89f5ab47139c1201fb9015df17ec45'
-- where username = 'admin';

update users set
  secret_question = null,
  secret_answer = null
;

-- ---------------------------------------
select "Updating person names...";
-- ---------------------------------------

update person_name set
  prefix = scramble(prefix),
  given_name = scramble(given_name),
  middle_name = scramble(middle_name),
  family_name_prefix = scramble(family_name_prefix),
  family_name = scramble(family_name),
  family_name2 = scramble(family_name2),
  family_name_suffix = scramble(family_name_suffix),
  degree = scramble(degree),
  void_reason = scramble(void_reason)
where person_id not in (
  select person_id from users where username in ('admin','daemon','mseaton')
)
;

-- ---------------------------------------
select "Updating person addresses...";
-- ---------------------------------------

update person_address set
  country = scramble(country),
  state_province = scramble(state_province),
  county_district = scramble(county_district),
  city_village = scramble(city_village),
  postal_code = scramble(postal_code),
  address1 = scramble(address1),
  address2 = scramble(address2),
  address3 = scramble(address3),
  address4 = scramble(address4),
  address5 = scramble(address5),
  address6 = scramble(address6),
  latitude = scramble(latitude),
  longitude = scramble(longitude),
  void_reason = scramble(void_reason)
;

-- ---------------------------------------
select "Updating patient identifiers...";
-- ---------------------------------------

update patient_identifier set
  identifier = scramble(identifier),
  void_reason = scramble(void_reason)
;

-- TBD:  See if we can get these working by scrambling them
update patient_identifier_type set format = '';
update patient_identifier_type set validator = '';

-- ---------------------------------------
select "Updating person attributes...";
-- ---------------------------------------

update person_attribute set
  value = scramble(value)
where person_attribute_type_id in (
  select  person_attribute_type_id
  from    person_attribute_type
  where   format = 'java.lang.String'
);

-- ---------------------------------------
select "Updating Obs...";
-- ---------------------------------------

update obs set value_text = scramble(value_text) where value_text is not null;

-- ---------------------------------------
select "Updating Void and Retire Reasons...";
-- ---------------------------------------

update orders set void_reason = scramble(void_reason) where void_reason is not null;
update patient set void_reason = scramble(void_reason) where void_reason is not null;
update person set void_reason = scramble(void_reason) where void_reason is not null;
update person_attribute set void_reason = scramble(void_reason) where void_reason is not null;
update relationship set void_reason = scramble(void_reason) where void_reason is not null;
update users set retire_reason = scramble(retire_reason) where retire_reason is not null;

-- ---------------------------------------
select "Updating Cohort, Order Extension, Provider, and Usage Statistics..";
-- ---------------------------------------

update cohort set name = scramble(name) where name is not null;
update orderextension_order set administration_instructions = scramble(administration_instructions) where administration_instructions is not null;
update provider set identifier = scramble(identifier) where identifier is not null;
update usagestatistics_usage set query = scramble(query) where query is not null;

-- ---------------------------------------
select "Updating Global Properties...";
-- ---------------------------------------

update global_property set property_value = 'admin' where property like '%.username';
update global_property set property_value = 'Admin123' where property like '%.password';
update global_property set property_value = 'admin' where property like '%_username';
update global_property set property_value = 'Admin123' where property like '%_password';

-- ---------------------------------------
select "Clearing out unnecessary table data...";
-- ---------------------------------------

delete from concept_proposal_tag_map;
delete from concept_proposal;
delete from hl7_in_archive;
delete from hl7_in_error;
delete from hl7_in_queue;
delete from idgen_log_entry;
delete from formentry_error;
delete from formentry_xsn;
delete from user_property;
delete from name_phonetics;
delete from notification_alert_recipient;
delete from notification_alert;
delete from sync_server_record;
delete from sync_record;
delete from person_merge_log;

