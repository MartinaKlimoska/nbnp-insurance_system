create view all_policies
            (id, managerid, agentid, start_date, end_date, policypriceid, statusid, policyholderid, insurance_type,
             sub_type, policyattributes)
as
SELECT policy.id,
       policy.managerid,
       policy.agentid,
       policy.start_date,
       policy.end_date,
       policy.policypriceid,
       policy.policystatusid,
       policy.policyholderid,
       policy.insurance_type,
       policy.sub_type,
       policy.policyattributes
FROM policy;

alter table all_policies
    owner to postgres;

create view policies
            (policyholder, policystatus, insurancetype, insurancesubtype, startdate, enddate, baseprice, deductible,
             description, nameofagentsignedfirstname, nameofagentsignedlastname, managerapprovalfirstname,
             managerapprovallastname)
as
SELECT c.name            AS policyholder,
       p.status          AS policystatus,
       i.type            AS insurancetype,
       s.sub_type        AS insurancesubtype,
       policy.start_date AS startdate,
       policy.end_date   AS enddate,
       p2.base_price     AS baseprice,
       p2.deductible,
       p3.description,
       u.first_name      AS nameofagentsignedfirstname,
       u.last_name       AS nameofagentsignedlastname,
       u2.first_name     AS managerapprovalfirstname,
       u2.last_name      AS managerapprovallastname
FROM policy
         JOIN customer c ON policy.policyholderid = c.id
         LEFT JOIN policystatus p ON policy.policystatusid = p.id
         LEFT JOIN insurancetype i ON policy.insurance_type = i.id
         LEFT JOIN subtype s ON policy.sub_type = s.id
         LEFT JOIN policyprice p2 ON policy.policypriceid = p2.id
         LEFT JOIN "User" u ON policy.agentid = u.id
         LEFT JOIN "User" u2 ON policy.managerid = u.id
         LEFT JOIN policyatributes p3 ON policy.policyattributes = p3.id;

alter table policies
    owner to postgres;

create view all_users(first_name, last_name, phone, email, username, type) as
SELECT u.first_name,
       u.last_name,
       u.phone_no AS phone,
       u.email,
       u2.username,
       u3.type
FROM "User" u
         LEFT JOIN useraccount u2 ON u.id = u2.id
         LEFT JOIN usertype u3 ON u3.id = u.user_type;

alter table all_users
    owner to postgres;

create view policy_types(type, sub_type) as
SELECT i.type,
       s.sub_type
FROM subtype s
         LEFT JOIN insurancetype i ON i.id = s.type
ORDER BY i.type;

alter table policy_types
    owner to postgres;

create view all_claims (description, status, date, type, sub_type, name, address, email, phone_no) as
SELECT c.description,
       c.status,
       c.date,
       i.type,
       s.sub_type,
       c2.name,
       c2.address,
       c2.email,
       c2.phone_no
FROM claim c
         LEFT JOIN policy p ON p.id = c.policyid
         LEFT JOIN customer c2 ON c2.id = c.customer
         LEFT JOIN insurancetype i ON p.insurance_type = i.id
         LEFT JOIN subtype s ON p.sub_type = s.id;

alter table all_claims
    owner to postgres;

create view damages_report
            (damage_type, date_of_payment, status_of_payment, received_payment, received_from, description, status,
             date, type, sub_type, name)
as
SELECT d.damage_type,
       d2.date_of_payment,
       d2.status_of_payment,
       d2.received_payment,
       d2.received_from,
       c.description,
       c.status,
       c.date,
       i.type,
       s.sub_type,
       c2.name
FROM claim c
         LEFT JOIN policy p ON p.id = c.policyid
         LEFT JOIN customer c2 ON c2.id = c.customer
         LEFT JOIN insurancetype i ON p.insurance_type = i.id
         LEFT JOIN subtype s ON p.sub_type = s.id
         LEFT JOIN damage d ON d.policyid = p.id
         LEFT JOIN damagepayment d2 ON d.id = d2.damageid;

alter table damages_report
    owner to postgres;

create view policy_history
            (date_closed, id, managerid, agentid, start_date, end_date, policypriceid, statusid, policyholderid,
             insurance_type, sub_type, policyattributes)
as
SELECT ph.date_closed,
       p.id,
       p.managerid,
       p.agentid,
       p.start_date,
       p.end_date,
       p.policypriceid,
       p.policystatusid,
       p.policyholderid,
       p.insurance_type,
       p.sub_type,
       p.policyattributes
FROM policyhistory ph
         LEFT JOIN policy p ON ph.policyid = p.id;

alter table policy_history
    owner to postgres;

create view muncipality(id, municipality) as
SELECT municipality.id,
       municipality.municipality
FROM municipality;

alter table muncipality
    owner to postgres;

create view policy_payments(id, policyid, date, amount, type) as
SELECT policypayment.id,
       policypayment.id,
       policypayment.date,
       policypayment.amount,
       policypayment.type
FROM policypayment;

alter table policy_payments
    owner to postgres;

create view customer_type(type) as
SELECT c.type
FROM customertype c;

alter table customer_type
    owner to postgres;

create view user_type(type) as
SELECT u.type
FROM usertype u;

alter table user_type
    owner to postgres;


