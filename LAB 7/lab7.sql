--a
create function increment(a numeric)
    returns numeric as
$$
begin
    return a + 1;
end;
$$
language plpgsql;
--b
create function sum(a numeric, b numeric)
    returns numeric as
$$
begin
    return a + b;
end;
$$
language plpgsql;
--c
create function even(a int)
    returns boolean as
$$
begin
    if a % 2 = 0 then return true;
    else return false;
    end if;
end;
$$
language plpgsql;
--d
create function validity(s varchar)
    returns boolean as
$$
begin
    if LENGTH(s) > 7 then return true;
    else return false;
    end if;
end;
$$
language plpgsql;
--e
create function pow(a numeric, out square numeric, out cube numeric) as
$$
begin
    square = a * a;
    cube = square * a;
end;
$$
language plpgsql;


--a
create function current()
    returns trigger as
$$
begin
    raise notice '%',now();
    return new;
end;
$$
language plpgsql;

create trigger current_t before insert on table1 for each row execute procedure current();
--b
create function age()
    returns trigger as
$$
begin
    raise notice '%', age(now(),new.t);
    return new;
end;
$$
language plpgsql;

create trigger age_t before insert on table2 for each row execute procedure age();
--c
create function tax()
    returns trigger as
$$
begin
    new.cost = new.cost * 1.12;
    return new;
end;
$$
language plpgsql;

create trigger tax_t before insert on table3 for each row execute procedure tax();
--d
create function stop()
    returns trigger as
$$
begin
    raise exception 'Deletion is not allowed';
end;
$$
language plpgsql;

create trigger stop_t before delete on table4 execute procedure stop();
--e
create function call()
    returns trigger as
$$
begin
    raise notice '%', validity(new.s);
    raise notice '%', pow(new.a);
    return new;
end;
$$
language plpgsql;

create trigger call_t before insert on table5 for each row execute procedure call();


create table work(id int, name varchar, date_of_birth date, age int, salary numeric, workexperience int, discount numeric);
--a
create function
    a(id int, name varchar, date_of_birth date, age int, inout salary numeric, workexperience int, out discount numeric) as
$$
declare
    count int;
begin
    discount = 10;
    count = workexperience/2;
    for step in 1..count loop
        salary = salary * 1.1;
    end loop;
    count = workexperience/5;
    for step in 1..count loop
        discount = discount * 1.01;
    end loop;
    insert into work values(id, name, date_of_birth, age, salary, workexperience, discount);
end;
$$
language plpgsql;

select * from a(1, 'a', '2000-03-02', 22, 1000, 10);
--b
create or replace function
    b(id int, name varchar, date_of_birth date, age int, inout salary numeric, workexperience int, out discount numeric) as
$$
declare
    count int;
begin
    if age >= 40 then salary = salary * 1.15;
    end if;
    discount = 10;
    count = workexperience/2;
    for step in 1..count loop
        salary = salary * 1.1;
    end loop;
    count = workexperience/5;
    for step in 1..count loop
        discount = discount * 1.01;
    end loop;
    if workexperience > 8 then salary = salary * 1.15;
    end if;
    if workexperience > 8 then discount = 20;
    end if;
    insert into work values(id, name, date_of_birth, age, salary, workexperience, discount);
end;
$$
language plpgsql;

select * from b(2, 'b', '2000-03-02', 44, 1000, 10);