--a
select * from dealer cross join client;
--b
select dealer.id, dealer.name, client.id, client.name, client.city, client.priority, sell.id, sell.date, sell.amount
    from dealer inner join client on dealer.id = client.dealer_id inner join sell on client.id = sell.client_id;
--c
select dealer.id, dealer.name, client.id, client.name from dealer inner join client on dealer.location = client.city;
--d
select sell.id, sell.amount, client.id, client.name, client.city from sell inner join client on sell.client_id = client.id
    where sell.amount between 100 and 500;
--e
select distinct on (dealer.id) dealer.id, dealer.name, client.id, client.name from dealer
    left join client on dealer.id = client.dealer_id;
--f
select dealer.id, dealer.name, client.id, client.name, client.city, dealer.charge
    from dealer left join client on dealer.id = client.dealer_id;
--g
select dealer.id, dealer.name, client.id, client.name, client.city, dealer.charge
    from dealer inner join client on dealer.id = client.dealer_id where dealer.charge > 0.12;
--h
select distinct on (client.id) client.id, client.name, client.city, sell.id, sell.date, sell.amount,
    dealer.id, dealer.name, dealer.charge
        from client left join sell on client.id = sell.client_id left join dealer on sell.dealer_id = dealer.id;
--i
select dealer.id, dealer.name, client.id, client.name, client.priority, sell.id, sell.amount
    from dealer inner join client on dealer.id = client.dealer_id left join sell on client.id = sell.client_id;

--a
create view a as select date, count(distinct client_id), avg(amount), sum(amount) from sell group by date;
--b
create view b as select date, sum(amount) from sell group by date order by sum(amount) desc limit 5;
--c
create view c as select dealer_id, count(id), avg(amount), sum(amount) from sell where dealer_id is not null group by dealer_id;
--d
create view d as select dealer.location, sum(dealer.charge*sell.amount)
    from dealer left join sell on dealer.id = sell.dealer_id group by dealer.location;
--e
create view e as select dealer.location, count(sell.id), avg(sell.amount), sum(sell.amount)
    from dealer left join sell on dealer.id = sell.dealer_id group by dealer.location;
--f
create view f as select client.city, count(sell.id), avg(sell.amount), sum(sell.amount)
    from client left join sell on client.id = sell.client_id group by client.city;
--g
create view g as
    select a.city from client a inner join sell on a.id = sell.client_id group by a.city having sum(sell.amount) >
       (select sum(sell.amount) from dealer b inner join sell on b.id = sell.dealer_id where a.city = b.location group by b.location);