CREATE TABLE IF NOT EXISTS invoice (
  invoice_id INT PRIMARY KEY,
  customer_id TEXT NOT NULL,
  amount NUMERIC
);

INSERT INTO invoice (invoice_id, customer_id, amount)
VALUES (1, 'Edwin', 50.0),
       (2, 'Claudia', 120.0),
       (3, 'Mariana', 18.5)
ON CONFLICT (invoice_id) DO NOTHING;

-- Validar datos insertados 
SELECT * FROM invoice ORDER BY invoice_id;

