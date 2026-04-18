# Pruebas en Postman

Importa estos archivos desde Postman:

- `api/postman/ecommerce-api.postman_collection.json`
- `api/postman/local.postman_environment.json`

Flujo recomendado:

1. Levanta la API con Docker.
2. Verifica `GET {{baseUrl}}/health`.
3. Ejecuta `Report - Total Sold By Category` con `DB_DIALECT=mysql`.
4. Cambia el valor de `DB_DIALECT=postgres` en tu servicio API, reinicia el contenedor y vuelve a ejecutar `Report - Total Sold By Category`.
5. Ejecuta `Create Order Item - Valid`.
6. Ejecuta `Create Order Item - Invalid Subtotal` y confirma el error `Error: El subtotal no coincide con Precio * Cantidad`.
7. Para la tanda de 5 inserciones, usa `Create Order Item - Runner Row` con el archivo `api/postman/order-items-valid-5.json` en Collection Runner.

Endpoint agregado en el proyecto:

- `GET {{baseUrl}}/reports/total-sold-by-category`

Payload esperado para insertar un item válido:

```json
{
  "order_id": 1,
  "product_id": 1,
  "quantity": 2,
  "subtotal": 20.00
}
```

Payload inválido para forzar el rechazo:

```json
{
  "order_id": 1,
  "product_id": 1,
  "quantity": 2,
  "subtotal": 15.00
}
```

Valores del runner:

1. order_id 1, product_id 1, quantity 1, subtotal 10.00
2. order_id 2, product_id 2, quantity 2, subtotal 40.00
3. order_id 3, product_id 3, quantity 3, subtotal 90.00
4. order_id 4, product_id 4, quantity 4, subtotal 160.00
5. order_id 5, product_id 5, quantity 5, subtotal 250.00