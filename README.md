# Sistema de Análisis de Somatotipo y Recomendación Deportiva

## 📋 Descripción

Sistema experto desarrollado en Prolog que calcula el **somatotipo** de una persona basándose en mediciones antropométricas y recomienda los deportes más adecuados según su perfil corporal.

El somatotipo es un sistema de clasificación del físico humano en tres componentes:
- **Endomorfia**: Tendencia a la adiposidad y formas redondeadas
- **Mesomorfia**: Desarrollo muscular y óseo
- **Ectomorfia**: Linealidad y delgadez

## 🎯 Características

- ✅ Cálculo automático de los tres componentes del somatotipo
- ✅ Clasificación detallada del tipo de cuerpo (13+ categorías)
- ✅ Recomendación de los 10 deportes más adecuados
- ✅ Base de datos con más de 200 deportes para hombres y mujeres
- ✅ Cálculo de coordenadas X-Y para mapeo gráfico
- ✅ Distancia euclidiana para determinar deportes compatibles

## 📊 Mediciones Requeridas

El sistema solicita 10 mediciones antropométricas:

1. **Peso** (kg)
2. **Estatura** (cm)
3. **Pliegue Tríceps** (mm)
4. **Pliegue Subescapular** (mm)
5. **Pliegue Supraespinal** (mm)
6. **Pliegue Pantorrilla Medial** (mm)
7. **Diámetro Húmero** (cm)
8. **Diámetro Fémur** (cm)
9. **Perímetro Brazo Contraído** (cm)
10. **Perímetro Pantorrilla** (cm)

## 🚀 Uso

### Requisitos

- SWI-Prolog instalado en el sistema
- Terminal/consola

### Instalación de SWI-Prolog

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install swi-prolog
```

**macOS:**
```bash
brew install swi-prolog
```

**Windows:**
Descarga el instalador desde [https://www.swi-prolog.org/download/stable](https://www.swi-prolog.org/download/stable)

### Ejecución

1. Abre una terminal en el directorio del proyecto

2. Inicia SWI-Prolog con el archivo:
```bash
swipl Proyecto.pl
```

3. Ejecuta el predicado principal:
```prolog
?- calcular_somatotipo.
```

4. Ingresa las mediciones cuando se te soliciten (recuerda terminar cada número con un punto `.`)

5. Ingresa tu sexo cuando se solicite (`h` para hombre, `m` para mujer)

### Ejemplo de Ejecución

```prolog
?- calcular_somatotipo.
--- Ingrese las 10 mediciones antropométricas ---
NOTA: Ingrese números y termine cada uno con un PUNTO (.).
      (Ejemplo: 80. o 175.5.)

1. Peso (kg): 70.
2. Estatura (cm): 175.
3. Pliegue Tríceps (mm): 10.
4. Pliegue Subescapular (mm): 12.
5. Pliegue Supraespinal (mm): 8.
6. Pliegue Pantorrilla Medial (mm): 7.
7. Diámetro Húmero (cm): 6.8.
8. Diámetro Fémur (cm): 9.5.
9. Perímetro Brazo Contraído (cm): 32.
10. Perímetro Pantorrilla (cm): 37.

--- RESULTADOS DEL SOMATOTIPO ---
1. Endomorfia: 2.341
2. Mesomorfia: 4.876
3. Ectomorfia: 2.456

========================================================================
  Somatotipo final (Endo-Meso-Ecto): 2.3 - 4.9 - 2.5
  Tipo de cuerpo: Mesomorfo Balanceado
  Descripción: Alto desarrollo muscular y óseo (Músculo dominante)...
  Coordenadas (X, Y): (0.12, 5.05)
========================================================================

Ingrese su sexo (h para hombre, m para mujer): h.

--- DEPORTES RECOMENDADOS (Top 10 más cercanos) ---
  - Baloncesto, point guard (Distancia: 0.21)
  - Fútbol (Soccer) (Distancia: 0.64)
  ...
```

## 🧮 Fórmulas Utilizadas

### Endomorfia
```
S3P = Tríceps + Subescapular + Supraespinal
X = S3P × (170.18 / Estatura)
Endomorfia = -0.7182 + (0.1451 × X) - (0.00068 × X²) + (0.0000014 × X³)
```

### Mesomorfia
```
PBC = Perímetro_Brazo - (Tríceps / 10)
PPC = Perímetro_Pantorrilla - (Pantorrilla / 10)
Mesomorfia = (0.858 × Húmero) + (0.601 × Fémur) + (0.188 × PBC) + (0.161 × PPC) - (0.131 × Estatura) + 4.50
```

### Ectomorfia
```
IP = Estatura / ∛Peso

Si IP ≥ 40.75: Ectomorfia = (0.732 × IP) - 28.58
Si 38.25 < IP < 40.75: Ectomorfia = (0.463 × IP) - 17.63
Si IP ≤ 38.25: Ectomorfia = 0.1
```

### Coordenadas
```
X = Ectomorfia - Endomorfia
Y = (2 × Mesomorfia) - (Endomorfia + Ectomorfia)
```

## 📁 Estructura del Código

```
Proyecto.pl
├── Predicado principal
│   └── calcular_somatotipo/0
├── Entrada de datos
│   ├── obtener_medidas/10
│   └── preguntar/2
├── Cálculos
│   ├── calcular_endomorfia/5
│   ├── calcular_mesomorfia/8
│   ├── calcular_ectomorfia/3
│   └── calcular_coordenadas/5
├── Clasificación
│   └── clasificar_tipo_cuerpo/5
├── Recomendaciones
│   ├── recomendar_deportes/4
│   ├── tomar_primeros_10/2
│   ├── extraer_deportes/2
│   └── imprimir_recomendaciones/1
└── Base de datos
    ├── deporteH/3 (deportes para hombres)
    └── deporteM/3 (deportes para mujeres)
```

## 🏃 Deportes en la Base de Datos

El sistema incluye más de 200 perfiles deportivos para:

### Hombres
- Fútbol americano (8 posiciones)
- Béisbol (6 posiciones)
- Baloncesto (4 posiciones)
- Boxeo (5 categorías)
- Fútbol/Soccer (5 posiciones)
- Rugby (6 posiciones)
- Voleibol (7 posiciones)
- Atletismo (velocidad, media y larga distancia)
- Deportes de combate (judo, karate, taekwondo, lucha)
- Y muchos más...

### Mujeres
- Baloncesto (4 posiciones)
- Voleibol de playa (4 posiciones)
- Fútbol (5 posiciones)
- Sóftbol (4 posiciones)
- Atletismo (múltiples distancias)
- Deportes de combate
- Levantamiento de pesas
- Y muchos más...

## 📖 Tipos de Cuerpo

El sistema clasifica en las siguientes categorías:

1. **Central**: Proporciones equilibradas
2. **Endomorfo Balanceado**: Grasa dominante
3. **Mesomorfo Balanceado**: Músculo dominante
4. **Ectomorfo Balanceado**: Delgadez dominante
5. **Endomorfo-Mesomorfo**: Musculoso y redondo
6. **Meso-Ectomorfo**: Musculoso y esbelto
7. **Ectomorfo-Endomorfo**: Delgado con grasa
8. **Endo-Mesomórfico**: Corpulento con base muscular
9. **Endo-Ectomórfico**: Redondeado con estructura lineal
10. **Meso-Endomórfico**: Fuerte con tendencia a corpulencia
11. **Meso-Ectomórfico**: Delgado con buen desarrollo muscular
12. **Ecto-Endomórfico**: Delgado y suave
13. **Ecto-Mesomórfico**: Musculoso y esbelto

## 🔬 Metodología

El sistema utiliza:

1. **Método de Heath-Carter**: Estándar internacional para cálculo de somatotipo
2. **Distancia Euclidiana**: Para encontrar deportes similares en el espacio X-Y
3. **Base de datos empírica**: Perfiles de atletas profesionales de diversos deportes

## 👥 Aplicaciones

- Orientación deportiva personalizada
- Evaluación nutricional y fitness
- Investigación antropométrica
- Selección de talentos deportivos
- Programas de entrenamiento personalizados

## 📝 Notas Importantes

- Las mediciones deben ser precisas para resultados óptimos
- Se recomienda que un profesional capacitado tome las medidas
- Los pliegues cutáneos deben medirse con un calibrador (plicómetro)
- Los diámetros óseos requieren un calibrador de diámetros (antropómetro)
- Los perímetros se miden con cinta métrica antropométrica

## 🤝 Contribuciones

Este proyecto fue desarrollado como un sistema experto educativo. Se pueden añadir más deportes a la base de datos siguiendo el formato:

```prolog
deporteH('Nombre del deporte', CoordX, CoordY).
deporteM('Nombre del deporte', CoordX, CoordY).
```

## 📄 Licencia

Proyecto educativo de libre uso.

## 👨‍💻 Autor

Desarrollado en SWI-Prolog con soporte para caracteres UTF-8.

---

**¿Necesitas ayuda?** Consulta el archivo `FUNCIONAMIENTO.md` para una explicación detallada paso a paso del sistema.
