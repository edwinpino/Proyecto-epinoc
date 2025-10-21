CREATE TABLE IF NOT EXISTS invoice (
  invoice_id INT PRIMARY KEY,
  customer_id TEXT NOT NULL,
  amount NUMERIC,
  city_code TEXT
);

INSERT INTO invoice (invoice_id, customer_id, amount, city_code)
VALUES (1, 'Edwin', 50.0, 'BOG'),
       (2, 'Claudia', 120.0, 'CUC'),
       (3, 'Mariana', 18.5, 'SMA')
ON CONFLICT (invoice_id) DO NOTHING;

-- Validar datos insertados 
SELECT * FROM invoice ORDER BY invoice_id;

