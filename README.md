# Oliva y Pimienta 🍽️

Aplicación móvil desarrollada en **Flutter** para el restaurante "Oliva y Pimienta". Este proyecto implementa una interfaz moderna con `Material Design 3`, gestión interactiva del menú, uso de APIs de terceros y notificaciones locales.

## 🚀 Características Principales

- **Diseño Moderno:** Uso de Slivers (`CustomScrollView`, `SliverAppBar`) para una experiencia de navegación premium y fluida.
- **Autenticación (Mock):** Pantallas de Login y Registro con validaciones de formulario.
- **Notificaciones Locales:** Integración multiplataforma de notificaciones (Windows, Android, iOS) que se disparan al iniciar sesión exitosamente.
- **Consumo de API:** Integración con la API pública [TheMealDB](https://www.themealdb.com/api.php) para cargar dinámicamente:
  - Listado de categorías de comida.
  - Recetas e imágenes reales de platillos.
- **Filtro de Búsqueda Avanzado:** 
  - **Por Nombre:** Barra de búsqueda en tiempo real para encontrar platillos específicos.
  - **Por Categoría:** Botones interactivos (Chips) para filtrar el listado (Todas, Postres, Platos Fuertes, Sopas).
- **Menú Lateral (Drawer):** Accesos rápidos sincronizados que filtran automáticamente las categorías en la pantalla principal.

## 🛠️ Tecnologías y Paquetes

- **[Flutter](https://flutter.dev/):** Framework de desarrollo UI.
- **[http](https://pub.dev/packages/http):** Para el consumo de la API REST de comida.
- **[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications):** Para las notificaciones nativas en dispositivos móviles.
- **[local_notifier](https://pub.dev/packages/local_notifier):** Para soportar notificaciones nativas de escritorio (Windows).

## 📂 Estructura del Proyecto

```text
lib/
 ┣ screens/
 ┃ ┣ home_page.dart        # Vista principal del menú y buscador
 ┃ ┣ login_page.dart       # Pantalla de inicio de sesión
 ┃ ┗ register_page.dart    # Pantalla de registro
 ┣ services/
 ┃ ┣ api_service.dart      # Lógica de consumo de TheMealDB
 ┃ ┗ notificacion_service.dart # Controlador de notificaciones multiplataforma
 ┣ theme/
 ┃ ┗ app_theme.dart        # Configuración centralizada de colores y tipografía
 ┣ widgets/
 ┃ ┣ drawer_tile.dart      # Componente para las opciones del menú lateral
 ┃ ┣ menu_card.dart        # Tarjeta para mostrar cada platillo con su imagen de red
 ┃ ┗ section_header.dart   # Encabezados de secciones
 ┗ main.dart               # Punto de entrada de la aplicación
```

## 💻 Instalación y Uso

1. Asegúrate de tener instalado el SDK de Flutter (`flutter doctor`).
2. Abre una terminal en la raíz del proyecto.
3. Ejecuta el siguiente comando para descargar e instalar todas las dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la aplicación en tu emulador o dispositivo conectado:
   ```bash
   flutter run
   ```
