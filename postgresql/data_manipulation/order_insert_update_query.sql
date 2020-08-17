insert into orders (products, info, meta, screenshot)
values (ARRAY [gen_random_uuid(),gen_random_uuid()], '{"paytype": "alipay"}', '{"paytype": "alipay"}',
        '"paperback" => "243"');
select * from orders;