# operators
## Arithmetic operator
select 1 + 2 as additon, 3 - 2 as minus, 2 * 3 as multiplication, 6 / 2 as division;
# Logical operator
select 2 & 3 as op_and, 2 | 3 as op_or, 2 ^ 3 as op_xor;
select 'a' is null, 'a' is not null, '' is null, '' is not null;

## shift
select 8 as a, 8 << 1 as left_shift_a, 8 >> 3 as right_shift_b;
## comparison operator
select 1 > 0, 2 < 3, 1 = 1, 2 != 1, 2 <> 1;
select 3 between 1 and 4, 2 in (1, 2);
select 'aaa' like '%a%', 'aaa' not like '%a%';

