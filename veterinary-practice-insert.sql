-- Veterinary Practice Database Solution and Queries
-- by Conor Dowdall
--
--
-- this script is executable using the following command:
-- source PATH_TO_FILE/FILENAME.sql
--
--
-- insert test data
INSERT INTO roles
VALUES (NULL, 'vet'),
    (NULL, 'nurse'),
    (NULL, 'receptionist');
INSERT INTO fees
VALUES (NULL, 'cancellation', 20.0),
    (NULL, 'consultation', 50.0),
    (NULL, 'dog worming', 30.0);
INSERT INTO employees
VALUES (
        NULL,
        1,
        'Aaron A. Anderson',
        '1 A-Street, A-Town, A-City, A-County, A-Country',
        'a@aa.aaa',
        '111-111-1111'
    ),
    (
        NULL,
        1,
        'Barbara B. Benson',
        '1 B-Street, B-Town, B-City, B-County, B-Country',
        'b@bb.bbb',
        '222-222-2222'
    );
INSERT INTO animals
VALUES (
        NULL,
        'A Aardvark Name',
        'aardvark',
        'a-subspecies',
        'Is afraid of everything. Treat with care.'
    ),
    (
        NULL,
        'B Badger Name',
        'badger',
        NULL,
        'Bites. Bites. Bites. Watch out!'
    );
INSERT INTO customers
VALUES (
        NULL,
        1,
        'A Customer',
        'A Address',
        'a_customer@email.com',
        '555-555-5555'
    ),
    (
        NULL,
        2,
        'B Customer',
        'B Address',
        'b_customer@email.com',
        '555-555-5555'
    );
INSERT INTO appointments
VALUES (
        NULL,
        1,
        1,
        1,
        1,
        NOW() + INTERVAL 1 HOUR,
        NULL,
        'rash, scratching, worms?'
    ),
    (
        NULL,
        1,
        1,
        1,
        1,
        NOW() + INTERVAL 8 HOUR,
        NULL,
        'rash, scratching, worms?'
    ),
    (
        NULL,
        2,
        2,
        2,
        2,
        NOW() + INTERVAL 2 HOUR,
        NULL,
        'no appetite, fever'
    );
INSERT INTO treatments
VALUES (
        NULL,
        1,
        'visible worms',
        'worm medication',
        true,
        80.0
    ),
    (
        NULL,
        2,
        'worms gone, aardvark happy',
        NULL,
        false,
        0.0
    ),
    (
        NULL,
        3,
        'angry badger',
        'badger valium',
        false,
        100.0
    );
INSERT INTO payments
VALUES (NULL, 1, NULL, 40.0, 'credit card', DEFAULT),
    (NULL, 3, NULL, 50.0, 'credit card', DEFAULT),
    (NULL, 3, NULL, 50.0, 'credit card', DEFAULT),
    (NULL, 1, NULL, 20.0, 'credit card', DEFAULT),
    (NULL, NULL, 2, 5.0, 'cash', DEFAULT),
    (NULL, NULL, 2, 5.0, 'cash', DEFAULT);