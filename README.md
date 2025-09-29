# Flutter CRUD

API usada: DummyJSON (https://dummyjson.com) — productos.

Para la práctica usé **DummyJSON**, una API pública que sirve datos falsos (mockeados) para pruebas y desarrollo.  
Características principales:
- Proporciona endpoints REST para recursos comunes (productos).
- Ideal para prototipos: no requiere autenticación y tiene respuestas consistentes.
- Los datos son sintéticos: cualquier cambio no representa datos reales ni persistencia a largo plazo.

Cómo ejecutar:
1. flutter pub get
2. flutter run

Arquitectura:
- lib/models -> Product
- lib/services -> ApiService (GET/POST/PUT/DELETE/search)
- lib/providers -> ProductProvider (estado y paginación)
- lib/screens -> list_screen.dart, detail_screen.dart, form_screen.dart

Notas:
- Búsqueda: implementada localmente filtrando por `title`.
- Validaciones: el formulario valida campos obligatorios, como el precio.


Link del video de muestra:
https://www.youtube.com/watch?v=_4IyujA6GI8


