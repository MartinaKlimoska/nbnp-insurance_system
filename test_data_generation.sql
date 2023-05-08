DO $$
DECLARE
    countNum integer := 1;
    municipality integer := (SELECT COUNT(*) FROM municipality);
    municipalityCounter integer := 1;
    city integer := (SELECT COUNT(*) FROM city);
    cityCounter integer := 1;
    settlement integer := (SELECT COUNT(*) FROM settlement);
    settlementCounter integer := 1;
BEGIN
    WHILE countNum < 500000 LOOP
        INSERT INTO customer
        VALUES (
            countNum,
            CONCAT('Name', countNum),
            CONCAT('Street', FLOOR(RANDOM()*100)+1, ', ', FLOOR(RANDOM()*1000)+1, ', ', FLOOR(RANDOM()*100)+1),
            CONCAT('user', countNum, '@example.com'),
            CONCAT('+389-7', FLOOR(RANDOM()*(9-1+1)+1), '-', RIGHT('000' || CAST(FLOOR(RANDOM()*(999-1+1)+1) AS VARCHAR(3)), 3), '-', RIGHT('000' || CAST(FLOOR(RANDOM()*(999-1+1)+1) AS VARCHAR(3)), 3)),
            municipalityCounter,
            settlementCounter,
            cityCounter,
            1,
            ROUND(RANDOM() + 1)
        );
        countNum := countNum+1;
        municipalityCounter := municipalityCounter+1;
        cityCounter := cityCounter+1;
        settlementCounter := settlementCounter+1;
        IF municipalityCounter>municipality THEN
            municipalityCounter := 1;
        END IF;
        IF cityCounter>city THEN
            cityCounter := 1;
        END IF;
        IF settlementCounter>settlement THEN
            settlementCounter := 1;
        END IF;
    END LOOP;
END $$;

/*
    user              done
    user account      done
    customer          done
    policy payment    done
    policy attributes done
    policy price      done
    policy            done
    claims            done
    insured           done
    policy history    done
    damage            done
    damage payment    done
 */

DO $$
DECLARE
    countNum integer := 1;
    usertype integer := (SELECT COUNT(*) FROM usertype);
    usertypeCounter integer := 1;
BEGIN
    WHILE countNum < 500 LOOP
        INSERT INTO "User"
        VALUES (
            countNum,
            CONCAT('FName', countNum),
		CONCAT('LName', countNum),
            CONCAT('user', countNum, '@', 'example', '.com'),
            CONCAT('+3897', FLOOR(RANDOM()*(9-1+1)+1), RIGHT('000' || CAST(FLOOR(RANDOM()*(999-1+1)+1) AS VARCHAR(3)), 3), RIGHT('000' || CAST(FLOOR(RANDOM()*(999-1+1)+1) AS VARCHAR(3)), 3)),
            usertypeCounter
        );
        countNum := countNum+1;
        usertypeCounter := usertypeCounter+1;
        IF usertypeCounter>usertype THEN
            usertypeCounter := 1;
        END IF;
    END LOOP;
END $$;


DO $$
DECLARE
    countNum integer := 1;
    user integer := (SELECT COUNT(*) FROM "User");
    userCounter integer := 1;
    fnames varchar[] := array(SELECT first_name FROM "User");
    roles varchar[] := array(SELECT user_type FROM "User");
BEGIN
    WHILE countNum < 500 LOOP
        INSERT INTO "useraccount"
        VALUES (
            countNum,
            CONCAT(fnames[countNum],'@', roles[countNum], 'team'),
		    CONCAT(hashtext(fnames[countNum]))
        );
        countNum := countNum+1;
    END LOOP;
END $$;

DO $$
DECLARE
    countNum integer := 1000;
    i integer := 1;
    j integer := 1;
    agents integer[] := array(SELECT id FROM "User" WHERE user_type = 1);
    a integer := (SELECT COUNT(*) FROM "User" WHERE user_type = 1);
    managers integer[] := array(SELECT id FROM "User" WHERE user_type = 3);
    m integer := (SELECT COUNT(*) FROM "User" WHERE user_type = 3);
    sub_type integer[] := array(SELECT id FROM subtype);
    subt integer := (SELECT COUNT(*) FROM subtype);
    type integer[] := array(SELECT type FROM subtype);
    status integer := (SELECT COUNT(*) FROM policystatus);
    holder integer[] := array(SELECT id FROM customer);
    h integer := (SELECT COUNT(*) FROM customer);
    new_subtype integer := 1;
    n integer := 1;
    p integer := (SELECT COUNT(*) FROM paymenttype);
    d date;
    d2 date;
BEGIN
    WHILE countNum < 1000000 LOOP
      d := date(CONCAT(CAST(floor(random()*5)+2018 as varchar(4)), '-', right('00'||cast(floor(random()*12)+1 as varchar(2)),2), '-', right('00'||cast(floor(random()*12)+1 as varchar(2)),2)));
      d2 := date(CONCAT(CAST(floor(random()*5)+2018 as varchar(4)), '-', right('00'||cast(floor(random()*12)+1 as varchar(2)),2), '-', right('00'||cast(floor(random()*12)+1 as varchar(2)),2)));
	  new_subtype := floor(random()*subt+1);
	  n := FLOOR(RANDOM()*3000+500);
        INSERT INTO policyprice
        VALUES (
            countNum,
            type[new_subtype],
            n,
            CEIL((RANDOM()*15+5)*n/100)
        );
	    INSERT INTO policypayment
	    VALUES (
	            countNum,
	            d,
	            n,
	            floor(random()*p+1)
        );
	    INSERT INTO policyatributes
	    VALUES (
	            countNum,
	            concat(''),
	            RIGHT('000' || CAST(FLOOR(RANDOM()*(999-1+1)+1) AS VARCHAR(3)), 3),
	            CONCAT('description', countNum),
	            CONCAT(n%10),
	            CONCAT(' ', countNum*random())
        );
	    INSERT INTO policy
	    VALUES (
	            countNum,
	            managers[i],
	            agents[j],
	            d,
	            d2,
                countNum,
	            floor(random()*status+1),
	            holder[floor(random()*h+1)],
	            countNum,
	            type[new_subtype],
	            sub_type[new_subtype],
	            countNum
        );
        countNum := countNum+1;
	    i := i+1;
	    IF i >= m THEN
            i := 1;
        end if;
	   j := j+1;
	   if j>=a then
           j := 1;
       end if;
    END LOOP;
END $$;


DO $$
DECLARE
    countNum integer := 1;
    i integer := 1;
    j integer := 1;
    agents integer[] := array(SELECT id FROM "User" WHERE user_type = 6);
    a integer := (SELECT COUNT(*) FROM "User" WHERE user_type = 6);
    holder integer[] := array(SELECT id FROM customer);
    h integer := (SELECT COUNT(*) FROM customer);
    p integer := (SELECT COUNT(*) FROM policystatus);
    d date;
BEGIN
    WHILE countNum < 200000 LOOP
      d := date(CONCAT(CAST(floor(random()*5)+2018 as varchar(4)), '-', right('00'||cast(floor(random()*12)+1 as varchar(2)),2), '-', right('00'||cast(floor(random()*12)+1 as varchar(2)),2)));

        INSERT INTO claim
      VALUES(
             countNum,
             FLOOR(RANDOM()*1000000+1),
             d,
             concat('description', countNum),
             agents[j],
             holder[i],
             floor(random()*p+1)
            );

        countNum := countNum+1;
	    i := i+1;
	    IF i >= h THEN
            i := 1;
        end if;
	   j := j+1;
	   if j>=a then
           j := 1;
       end if;
    END LOOP;
END $$;


DO $$
DECLARE
    countNum integer := 1;
    d date;
    claims integer[] := array(SELECT id from claim where status = 3);
    c integer = (select count(*) from claim where status = 3);
    policys integer[] := array(select policyid from claim where status = 3);
    type varchar[] := array (Select type from insurancetype);
    n integer;
    n2 integer;
BEGIN
    WHILE countNum < c LOOP
      d := date(CONCAT(CAST(floor(random()*5)+2018 as varchar(4)), '-', right('00'||cast(floor(random()*12)+1 as varchar(2)),2), '-', right('00'||cast(floor(random()*12)+1 as varchar(2)),2)));
        n := floor(random()*c+1);
        n2 := floor(random()*8+1);
        INSERT INTO damage
      VALUES(
             countNum,
             policys[n],
             claims[n],
             type[n2]
            );
      INSERT INTO damagepayment
      VALUES(
             countNum,
             countNum,
             true,
             floor(random()*500000+1000),
             concat('received from ', countNum),
             concat('paid to '),
             d
            );

        countNum := countNum+1;
    END LOOP;
END $$;


DO $$
DECLARE
    policies integer[] := array (select id from policy);
    customers integer[] := array (select id from customer);
    countNum integer := 1;
BEGIN
    WHILE countNum < 50000 LOOP

        INSERT INTO insured
      VALUES(
             countNum,
             policies[floor(random()*1000000)+1],
             customers[floor(random()*500000)+1]
            );

        countNum := countNum+1;
    END LOOP;
END $$;