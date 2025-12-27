# BRUMA - Aplicación iOS de Música

Aplicación iOS nativa para reproducción de música que permite buscar canciones, visualizar charts populares, reproducir previews de 30 segundos y guardar favoritos localmente.

## Estado del Proyecto

✅ **Código Swift completo** - Todos los archivos Swift están creados y listos
⚠️ **Configuración de Storyboard pendiente** - Requiere configuración manual en Xcode

## Archivos Creados

### Modelos (4 archivos)
- ✅ `Track.swift` - Modelo de canción
- ✅ `Artist.swift` - Modelo de artista
- ✅ `Album.swift` - Modelo de álbum
- ✅ `DeezerResponse.swift` - Respuestas de la API

### Services (3 archivos)
- ✅ `NetworkManager.swift` - Manejo de API de Deezer
- ✅ `CoreDataManager.swift` - Persistencia de favoritos
- ✅ `AudioPlayerManager.swift` - Reproducción de audio

### ViewControllers (4 archivos)
- ✅ `HomeViewController.swift` - Pantalla de Charts
- ✅ `SearchViewController.swift` - Pantalla de búsqueda
- ✅ `FavoritesViewController.swift` - Pantalla de favoritos
- ✅ `TrackDetailViewController.swift` - Detalle de canción

### Celdas Personalizadas (2 archivos)
- ✅ `TrackTableViewCell.swift` - Celda para TableView
- ✅ `ChartCollectionViewCell.swift` - Celda para CollectionView

### Extensions (1 archivo)
- ✅ `UIImageView+URL.swift` - Carga de imágenes desde URL

### Configuraciones
- ✅ `Info.plist` - Actualizado con NSAppTransportSecurity
- ✅ Core Data Model - Entidad FavoriteSong configurada

## Próximos Pasos

### 1. Abrir en Xcode (macOS requerido)
```bash
# En tu Mac, abre el proyecto:
open Proyecto_Cibertec_DAM2.xcodeproj
```

### 2. Agregar archivos al proyecto
Ver instrucciones detalladas en `SETUP_GUIDE.md` - Paso 2

### 3. Configurar Storyboard
Ver instrucciones detalladas en `SETUP_GUIDE.md` - Pasos 3-7

### 4. Compilar y probar
- Selecciona un simulador iOS 17.0+
- Presiona ⌘R para ejecutar

## Documentación

- **`SETUP_GUIDE.md`** - Guía paso a paso completa para configurar el proyecto en Xcode
- **`BRUMA_SPEC_TECNICA.md`** - Especificación técnica detallada del proyecto

## Requisitos

- macOS con Xcode 15+
- iOS 17.0+ (simulador o dispositivo)
- Conexión a internet (para API de Deezer)

## Tecnologías

- **Lenguaje**: Swift 5.9+
- **UI**: UIKit + Storyboards
- **Arquitectura**: MVC
- **Persistencia**: Core Data
- **Audio**: AVFoundation
- **API**: Deezer API (pública, sin autenticación)

## Funcionalidades

✅ Búsqueda de canciones y artistas
✅ Visualización de charts populares
✅ Reproducción de previews de 30 segundos
✅ Guardar y eliminar favoritos
✅ Persistencia local con Core Data
✅ Interfaz con Tab Bar (3 pestañas)

## Estructura del Proyecto

```
Proyecto_Cibertec_DAM2/
├── Models/               # Modelos de datos
├── Services/             # Managers (Network, CoreData, Audio)
├── Controllers/          # ViewControllers
├── Views/Cells/          # Celdas personalizadas
├── Extensions/           # Extensiones de UIKit
├── Main.storyboard       # UI principal
└── *.xcdatamodeld        # Modelo Core Data
```

## API Utilizada

**Deezer API** (https://api.deezer.com)
- Endpoint de búsqueda: `/search?q={query}`
- Endpoint de charts: `/chart/0/tracks`
- No requiere API key ni autenticación
- Previews de audio de 30 segundos

## Autor

Proyecto desarrollado para el curso de Desarrollo de Aplicaciones Móviles 2 - Cibertec

## Licencia

Proyecto educativo - Cibertec 2025
