# HCKMX26-1776370994

# Duukar

Duukar es una aplicación móvil de prevención digital para niñas, niños y adolescentes mexicanos. Su objetivo es ayudarles a reconocer señales de manipulación, grooming, falsas oportunidades, estafas, normalización del crimen y posibles intentos de captación o reclutamiento en entornos digitales. A través de **Duki**, un asistente interactivo adaptado por rango de edad, la app combina aprendizaje gamificado, análisis voluntario de capturas, texto y enlaces sospechosos, y orientación clara para tomar decisiones seguras.

---

## Problema que resuelve

Niñas, niños y adolescentes están expuestos a riesgos digitales cada vez más complejos: grooming, manipulación emocional, estafas, falsas promesas de dinero, retos peligrosos y contenido que romantiza dinámicas dañinas. Muchas veces estos riesgos no se presentan como amenazas directas, sino como oportunidades atractivas, vínculos afectivos o contenido aspiracional.

Los controles parentales tradicionales no siempre funcionan en estos contextos, especialmente cuando:

- el menor no quiere sentirse vigilado,
- no existe una red de apoyo cercana o funcional,
- el riesgo aparece en plataformas y formatos muy diversos,
- la manipulación se disfraza de ayuda, pertenencia, fama o dinero fácil.

Duukar propone un enfoque distinto: **prevención no invasiva**, aprendizaje activo y análisis bajo demanda. En lugar de vigilar permanentemente al usuario, la aplicación le enseña a reconocer señales de riesgo y le permite consultar a Duki cuando algo le genera dudas.

---

## Tecnologías y herramientas utilizadas

### Desarrollo
- **Flutter**: desarrollo de la aplicación móvil con una sola base de código.
- **Dart**: lenguaje principal del proyecto.

### Backend y datos
- **Supabase**: autenticación, base de datos PostgreSQL y almacenamiento de datos estructurados.

### Inteligencia artificial
- **OpenAI API**: análisis de texto, capturas y enlaces mediante prompts adaptados al rango de edad del usuario.

### Diseño y prototipado
- **Google Stitch**: generación inicial de conceptos visuales y exploración rápida de pantallas.
- **Figma / herramientas de diseño visual**: refinamiento del flujo y de la interfaz final del prototipo.

### Organización y apoyo al desarrollo
- **Git / GitHub**: control de versiones y entrega del prototipo.
- **IA generativa para apoyo de arquitectura, UX writing y documentación**: apoyo en definición de estructura, pantallas, contenido y README.

> Nota: algunas herramientas pueden ajustarse al cierre del hackathon dependiendo de la implementación final efectivamente usada.

---

## Instrucciones para ejecutar el prototipo

### Requisitos previos
- Tener instalado **Flutter SDK**.
- Tener configurado un entorno para correr Flutter en Android.
- Tener acceso al archivo de variables de entorno o credenciales necesarias si el proyecto usa servicios externos.

### Pasos generales
1. Clonar el repositorio:

```bash
git clone https://github.com/startuplab-mx/HCKMX26-1776370994.git
cd duukar
```

2. Instalar dependencias:

```bash
flutter pub get
```

3. Configurar variables de entorno o credenciales necesarias:
- URL y key de Supabase
- API key del servicio de IA utilizado

4. Ejecutar la aplicación:

```bash
flutter run
```

### Si se requiere compilación para Android

```bash
flutter build apk
```

> Estas instrucciones podrán complementarse o ajustarse al finalizar la implementación, de acuerdo con la configuración final del proyecto.

---

## Herramientas de IA utilizadas

Esta sección documenta explícitamente el uso de herramientas de IA dentro del proyecto, tanto en el producto como en el proceso de desarrollo.

### 1. OpenAI API
**Uso:** análisis de contenido sospechoso compartido voluntariamente por el usuario.

**Para qué se utilizó:**
- detectar señales de manipulación,
- identificar posibles patrones de grooming,
- analizar falsas promesas o contenido “demasiado bueno para ser real”,
- explicar el riesgo en lenguaje adaptado a la edad,
- proponer acciones seguras para el usuario.

**En qué medida:**
- uso central dentro del prototipo funcional,
- utilizada para la lógica de análisis y respuesta de Duki,
- su salida esperada es estructurada para facilitar la interpretación dentro de la app.

### 2. IA generativa para diseño y UX
**Uso:** apoyo en ideación de flujo, estructura de pantallas, copies y conceptos visuales.

**Herramientas utilizadas:**
- Google Stitch
- asistentes de IA para diseño conversacional y definición de pantallas

**Para qué se utilizó:**
- generar primeras propuestas de interfaz,
- explorar estilos visuales,
- organizar pantallas por flujo,
- acelerar decisiones de diseño durante el hackathon.

**En qué medida:**
- apoyo parcial y acelerador creativo,
- el criterio final de producto, jerarquía visual y selección de pantallas fue definido por el equipo.

### 3. IA generativa para desarrollo y documentación
**Uso:** apoyo técnico en arquitectura Flutter, organización de carpetas, definición de navegación, naming y documentación.

**Para qué se utilizó:**
- proponer estructura base del proyecto,
- reducir riesgo de código espagueti,
- apoyar la redacción del README,
- ayudar a documentar decisiones técnicas y funcionales.

**En qué medida:**
- apoyo significativo como asistente técnico,
- la implementación, selección final y validación de decisiones fue realizada por el equipo.

> Importante: la IA fue utilizada como herramienta de apoyo, aceleración y asistencia. Las decisiones de producto, alcance, enfoque ético y validación final fueron responsabilidad del equipo desarrollador.

---

## Integrantes del equipo

### Perla
- Project Manager
- Definición de producto, narrativa, flujo y coordinación general

### Angela
- Desarrolladora móvil
- Implementación en Flutter, integración técnica y desarrollo del prototipo

### Julián
- Apoyo remoto
- Análisis de datos, estructuración de casos y soporte en validación conceptual

---

## Estado del proyecto

Actualmente, Duukar se encuentra en etapa de prototipo funcional para hackathon. El alcance prioriza:

- onboarding inicial,
- cápsulas educativas obligatorias,
- consulta con Duki mediante captura, texto o enlace,
- análisis de riesgo con IA,
- recomendaciones de acción,
- sistema inicial de recompensas y progreso,
- base de reportes estructurados.

Algunas funcionalidades del diseño completo pueden permanecer como visión de producto o siguiente fase, dependiendo del tiempo de implementación disponible durante el hackathon.

---

## Enfoque ético y de privacidad

Duukar prioriza un enfoque de **prevención no invasiva**. La aplicación no está planteada como sistema de vigilancia permanente, sino como una herramienta de aprendizaje y consulta voluntaria. El usuario decide qué contenido compartir para analizar, y el sistema busca minimizar el almacenamiento de información sensible, privilegiando reportes estructurados y explicaciones claras.

---

## Pendientes de validación al cierre

Antes de la entrega final, esta documentación debe revisarse para confirmar:

- herramientas efectivamente implementadas,
- dependencias finales del proyecto,
- flujo exacto del MVP entregado,
- configuración real de ejecución,
- grado final de uso de IA en producto y desarrollo.
