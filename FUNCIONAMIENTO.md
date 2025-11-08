# Funcionamiento Detallado del Sistema de Somatotipo

## 📚 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Flujo General del Sistema](#flujo-general-del-sistema)
3. [Paso 1: Recolección de Datos](#paso-1-recolección-de-datos)
4. [Paso 2: Cálculo de Endomorfia](#paso-2-cálculo-de-endomorfia)
5. [Paso 3: Cálculo de Mesomorfia](#paso-3-cálculo-de-mesomorfia)
6. [Paso 4: Cálculo de Ectomorfia](#paso-4-cálculo-de-ectomorfia)
7. [Paso 5: Cálculo de Coordenadas](#paso-5-cálculo-de-coordenadas)
8. [Paso 6: Clasificación del Tipo de Cuerpo](#paso-6-clasificación-del-tipo-de-cuerpo)
9. [Paso 7: Recomendación de Deportes](#paso-7-recomendación-de-deportes)
10. [Ejemplos Prácticos](#ejemplos-prácticos)

---

## Introducción

Este documento explica paso a paso cómo funciona el sistema experto de análisis de somatotipo. El sistema está escrito en Prolog y utiliza el método de Heath-Carter para calcular el somatotipo corporal.

### ¿Qué es el Somatotipo?

El somatotipo es una forma de describir la composición corporal de una persona mediante tres números que representan:

- **Endomorfia (1er número)**: Nivel de adiposidad o grasa corporal
- **Mesomorfia (2do número)**: Nivel de desarrollo muscular y óseo
- **Ectomorfia (3er número)**: Nivel de linealidad y delgadez

Por ejemplo, un somatotipo de `3-5-2` indica:
- Endomorfia baja-moderada (3)
- Mesomorfia alta (5) - componente dominante
- Ectomorfia baja (2)

Este perfil sería típico de un atleta musculoso con poca grasa.

---

## Flujo General del Sistema

```
┌─────────────────────────────────────┐
│  1. Inicio: calcular_somatotipo/0   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  2. Solicitar 10 mediciones         │
│     (obtener_medidas/10)            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  3. Calcular Endomorfia             │
│     (calcular_endomorfia/5)         │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  4. Calcular Mesomorfia             │
│     (calcular_mesomorfia/8)         │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  5. Calcular Ectomorfia             │
│     (calcular_ectomorfia/3)         │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  6. Calcular Coordenadas X, Y       │
│     (calcular_coordenadas/5)        │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  7. Clasificar Tipo de Cuerpo       │
│     (clasificar_tipo_cuerpo/5)      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  8. Solicitar Sexo (h/m)            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  9. Recomendar Deportes             │
│     (recomendar_deportes/4)         │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  10. Mostrar Top 10 Deportes        │
│      (imprimir_recomendaciones/1)   │
└─────────────────────────────────────┘
```

---

## Paso 1: Recolección de Datos

### Predicado: `obtener_medidas/10`

Este predicado solicita al usuario las 10 mediciones antropométricas necesarias.

**Código:**
```prolog
obtener_medidas(Peso, Estatura, P_Tri, P_Sub, P_Sup, P_Pan, D_Hum, D_Fem, Per_Bra, Per_Pan) :-
    write('--- Ingrese las 10 mediciones antropométricas ---'), nl,
    preguntar('1. Peso (kg): ', Peso),
    preguntar('2. Estatura (cm): ', Estatura),
    % ... y así sucesivamente
```

**Funcionamiento:**

1. **Muestra instrucciones**: Le indica al usuario que debe terminar cada número con un punto (`.`)
2. **Solicita cada medida**: Usa el predicado auxiliar `preguntar/2`
3. **Almacena valores**: Guarda cada medida en variables que se usarán después

**Ejemplo de uso:**
```prolog
?- obtener_medidas(Peso, Estatura, P_Tri, P_Sub, P_Sup, P_Pan, D_Hum, D_Fem, Per_Bra, Per_Pan).
1. Peso (kg): 75.
2. Estatura (cm): 180.
...
```

### Predicado auxiliar: `preguntar/2`

```prolog
preguntar(Prompt, Valor) :-
    write(Prompt),
    read(Valor).
```

**Funcionamiento:**
1. Muestra el texto del prompt
2. Lee el valor ingresado por el usuario
3. Unifica el valor con la variable `Valor`

---

## Paso 2: Cálculo de Endomorfia

### Predicado: `calcular_endomorfia/5`

La endomorfia representa la adiposidad relativa. Se calcula usando tres pliegues cutáneos.

**Código:**
```prolog
calcular_endomorfia(P_Tri, P_Sub, P_Sup, Estatura, Endo) :-
    S3P is P_Tri + P_Sub + P_Sup,
    X is S3P * (170.18 / Estatura),
    Endo is -0.7182 + (0.1451 * X) - (0.00068 * X**2) + (0.0000014 * X**3).
```

**Funcionamiento paso a paso:**

1. **Suma de 3 pliegues (S3P)**:
   ```
   S3P = Tríceps + Subescapular + Supraespinal
   ```

2. **Corrección por estatura (X)**:
   ```
   X = S3P × (170.18 / Estatura)
   ```
   
   Esto normaliza los pliegues según una estatura de referencia de 170.18 cm.

3. **Aplicar ecuación cúbica de Heath-Carter**:
   ```
   Endo = -0.7182 + (0.1451 × X) - (0.00068 × X²) + (0.0000014 × X³)
   ```

**Ejemplo:**

Para una persona con:
- Tríceps = 10 mm
- Subescapular = 12 mm
- Supraespinal = 8 mm
- Estatura = 175 cm

```
S3P = 10 + 12 + 8 = 30
X = 30 × (170.18 / 175) = 29.17
Endo = -0.7182 + (0.1451 × 29.17) - (0.00068 × 29.17²) + (0.0000014 × 29.17³)
Endo = -0.7182 + 4.2327 - 0.5789 + 0.0348
Endo ≈ 2.97
```

**Interpretación:**
- < 2.5: Endomorfia baja (poca grasa)
- 2.5 - 5.0: Endomorfia moderada
- > 5.0: Endomorfia alta (mucha grasa)

---

## Paso 3: Cálculo de Mesomorfia

### Predicado: `calcular_mesomorfia/8`

La mesomorfia representa el desarrollo musculoesquelético.

**Código:**
```prolog
calcular_mesomorfia(Estatura, P_Tri, P_Pan, D_Hum, D_Fem, Per_Bra, Per_Pan, Meso) :-
    PBC is Per_Bra - (P_Tri / 10),
    PPC is Per_Pan - (P_Pan / 10),
    Meso is (0.858 * D_Hum) + (0.601 * D_Fem) + (0.188 * PBC) + 
            (0.161 * PPC) - (0.131 * Estatura) + 4.50.
```

**Funcionamiento paso a paso:**

1. **Corregir perímetros por pliegues (PBC, PPC)**:
   ```
   PBC = Perímetro_Brazo_Contraído - (Tríceps / 10)
   PPC = Perímetro_Pantorrilla - (Pliegue_Pantorrilla / 10)
   ```
   
   Los pliegues se dividen entre 10 para convertir de mm a cm, y se restan para obtener el perímetro muscular (sin grasa).

2. **Aplicar ecuación de Heath-Carter**:
   ```
   Meso = (0.858 × Húmero) + (0.601 × Fémur) + (0.188 × PBC) + 
          (0.161 × PPC) - (0.131 × Estatura) + 4.50
   ```

**Ejemplo:**

Para una persona con:
- Estatura = 175 cm
- Tríceps = 10 mm
- Pantorrilla = 7 mm
- Húmero = 6.8 cm
- Fémur = 9.5 cm
- Perímetro brazo = 32 cm
- Perímetro pantorrilla = 37 cm

```
PBC = 32 - (10 / 10) = 32 - 1 = 31 cm
PPC = 37 - (7 / 10) = 37 - 0.7 = 36.3 cm

Meso = (0.858 × 6.8) + (0.601 × 9.5) + (0.188 × 31) + (0.161 × 36.3) - (0.131 × 175) + 4.50
Meso = 5.83 + 5.71 + 5.83 + 5.84 - 22.93 + 4.50
Meso ≈ 4.78
```

**Interpretación:**
- < 3.0: Mesomorfia baja (poco músculo)
- 3.0 - 5.0: Mesomorfia moderada
- > 5.0: Mesomorfia alta (muy musculoso)

---

## Paso 4: Cálculo de Ectomorfia

### Predicado: `calcular_ectomorfia/3`

La ectomorfia representa la linealidad relativa. Se basa en el Índice Ponderal (IP).

**Código:**
```prolog
calcular_ectomorfia(Peso, Estatura, Ecto) :-
    IP is Estatura / (Peso**(1/3)),
    (   IP >= 40.75
    ->  Ecto is (0.732 * IP) - 28.58
    ;   IP < 40.75, IP > 38.25
    ->  Ecto is (0.463 * IP) - 17.63
    ;   Ecto is 0.1
    ).
```

**Funcionamiento paso a paso:**

1. **Calcular Índice Ponderal (IP)**:
   ```
   IP = Estatura / ∛Peso
   ```
   
   Este índice relaciona la estatura con el volumen corporal (el peso elevado a 1/3 representa aproximadamente el volumen).

2. **Aplicar ecuación según rango de IP**:
   
   **Si IP ≥ 40.75** (muy delgado):
   ```
   Ecto = (0.732 × IP) - 28.58
   ```
   
   **Si 38.25 < IP < 40.75** (moderadamente delgado):
   ```
   Ecto = (0.463 × IP) - 17.63
   ```
   
   **Si IP ≤ 38.25** (no delgado):
   ```
   Ecto = 0.1 (valor mínimo)
   ```

**Ejemplo:**

Para una persona con:
- Peso = 70 kg
- Estatura = 175 cm

```
IP = 175 / ∛70
IP = 175 / 4.121
IP ≈ 42.47

Como IP ≥ 40.75:
Ecto = (0.732 × 42.47) - 28.58
Ecto = 31.09 - 28.58
Ecto ≈ 2.51
```

**Interpretación:**
- < 2.5: Ectomorfia baja (robusto)
- 2.5 - 4.0: Ectomorfia moderada
- > 4.0: Ectomorfia alta (muy delgado)

---

## Paso 5: Cálculo de Coordenadas

### Predicado: `calcular_coordenadas/5`

Las coordenadas X e Y permiten representar el somatotipo en un plano cartesiano (somatocarta).

**Código:**
```prolog
calcular_coordenadas(Endo, Meso, Ecto, X, Y) :-
    X is Ecto - Endo,
    Y is (2 * Meso) - (Endo + Ecto).
```

**Funcionamiento:**

1. **Coordenada X**:
   ```
   X = Ectomorfia - Endomorfia
   ```
   
   Representa el eje de adiposidad-linealidad:
   - X negativo: Más endomorfo (más grasa)
   - X positivo: Más ectomorfo (más delgado)
   - X ≈ 0: Balance entre grasa y linealidad

2. **Coordenada Y**:
   ```
   Y = (2 × Mesomorfia) - (Endomorfia + Ectomorfia)
   ```
   
   Representa el eje de musculatura:
   - Y positivo: Alta mesomorfia (muy musculoso)
   - Y negativo: Baja mesomorfia (poco músculo)
   - Y ≈ 0: Mesomorfia moderada

**Ejemplo:**

Con Endo = 2.97, Meso = 4.78, Ecto = 2.51:

```
X = 2.51 - 2.97 = -0.46
Y = (2 × 4.78) - (2.97 + 2.51) = 9.56 - 5.48 = 4.08
```

**Visualización en somatocarta:**

```
        Y (Mesomorfia)
        │
      5 │      ●  (X=-0.46, Y=4.08)
        │     
      0 ├──────┼────── X (Ecto-Endo)
        │      
     -5 │
        
```

---

## Paso 6: Clasificación del Tipo de Cuerpo

### Predicado: `clasificar_tipo_cuerpo/5`

Clasifica el somatotipo en 13 categorías posibles según la dominancia de los componentes.

**Código (simplificado):**
```prolog
clasificar_tipo_cuerpo(Endo, Meso, Ecto, TipoCuerpo, Descripcion) :-
    DifEM is abs(Endo - Meso),
    DifEO is abs(Endo - Ecto),
    DifMO is abs(Meso - Ecto),
    
    % Verificar si es CENTRAL
    (   DifEM =< 0.5, DifEO =< 0.5, DifMO =< 0.5
    ->  TipoCuerpo = 'Central', ...
    
    % Verificar combinaciones balanceadas
    ;   DifEM =< 0.5, Endo > Ecto, Meso > Ecto
    ->  TipoCuerpo = 'Endomorfo-Mesomorfo', ...
    
    % ... más casos
    ).
```

**Funcionamiento:**

1. **Calcular diferencias entre componentes**:
   ```
   DifEM = |Endomorfia - Mesomorfia|
   DifEO = |Endomorfia - Ectomorfia|
   DifMO = |Mesomorfia - Ectomorfia|
   ```

2. **Clasificar según dominancia**:

   **Central** (todos equilibrados):
   - Las tres diferencias ≤ 0.5
   - Ejemplo: 4-4-4

   **Combinaciones balanceadas** (dos componentes similares y altos):
   - Endomorfo-Mesomorfo: Endo ≈ Meso, ambos > Ecto
   - Meso-Ectomorfo: Meso ≈ Ecto, ambos > Endo
   - Ectomorfo-Endomorfo: Ecto ≈ Endo, ambos > Meso

   **Dominancia simple** (un componente claramente mayor):
   - Endomorfo: Endo > Meso y Endo > Ecto
   - Mesomorfo: Meso > Endo y Meso > Ecto
   - Ectomorfo: Ecto > Endo y Ecto > Meso

   **Sub-clasificaciones**:
   - Endo-Mesomórfico: Endo dominante, Meso > Ecto
   - Endo-Ectomórfico: Endo dominante, Ecto > Meso
   - Y así sucesivamente...

**Ejemplo:**

Con Endo = 2.97, Meso = 4.78, Ecto = 2.51:

```
DifEM = |2.97 - 4.78| = 1.81
DifEO = |2.97 - 2.51| = 0.46
DifMO = |4.78 - 2.51| = 2.27

Meso > Endo (4.78 > 2.97) ✓
Meso > Ecto (4.78 > 2.51) ✓
DifEO ≤ 0.5 (0.46 ≤ 0.5) ✓

Clasificación: Mesomorfo Balanceado
```

---

## Paso 7: Recomendación de Deportes

### Predicado: `recomendar_deportes/4`

Encuentra los 10 deportes más compatibles basándose en la distancia euclidiana en el espacio X-Y.

**Código:**
```prolog
recomendar_deportes(X, Y, Sexo, ListaDeportes) :-
    findall(
        distancia(Distancia, Deporte),
        (
            (Sexo = h -> deporteH(Deporte, XDeporte, YDeporte) 
                      ; deporteM(Deporte, XDeporte, YDeporte)),
            Distancia is sqrt((X - XDeporte)**2 + (Y - YDeporte)**2)
        ),
        Distancias
    ),
    sort(Distancias, DistanciasOrdenadas),
    tomar_primeros_10(DistanciasOrdenadas, Top10),
    extraer_deportes(Top10, ListaDeportes).
```

**Funcionamiento paso a paso:**

1. **Seleccionar base de datos según sexo**:
   - Si Sexo = `h`: Usa `deporteH/3`
   - Si Sexo = `m`: Usa `deporteM/3`

2. **Calcular distancia euclidiana para cada deporte**:
   ```
   Distancia = √[(X - XDeporte)² + (Y - YDeporte)²]
   ```
   
   Esta fórmula calcula la distancia en línea recta entre el punto del usuario y el punto de cada deporte en la somatocarta.

3. **Ordenar deportes por distancia** (de menor a mayor):
   - Los deportes más cercanos son más compatibles

4. **Tomar los primeros 10**:
   - Retorna solo los 10 deportes más cercanos

**Ejemplo:**

Usuario: X = -0.46, Y = 4.08, Sexo = h

Deporte 1: Fútbol (Soccer), X = -0.4, Y = 5.6
```
Distancia = √[(-0.46 - (-0.4))² + (4.08 - 5.6)²]
Distancia = √[(-0.06)² + (-1.52)²]
Distancia = √[0.0036 + 2.3104]
Distancia = √2.314
Distancia ≈ 1.52
```

Deporte 2: Baloncesto, X = -0.3, Y = 5.3
```
Distancia = √[(-0.46 - (-0.3))² + (4.08 - 5.3)²]
Distancia = √[(-0.16)² + (-1.22)²]
Distancia = √[0.0256 + 1.4884]
Distancia = √1.514
Distancia ≈ 1.23
```

El sistema hace esto para todos los deportes y los ordena.

---

## Paso 8: Presentación de Resultados

### Predicado: `imprimir_recomendaciones/1`

Muestra la lista de deportes recomendados de forma legible.

**Código:**
```prolog
imprimir_recomendaciones([]).
imprimir_recomendaciones([resultado(Deporte, Distancia)|Resto]) :-
    format('  - ~w (Distancia: ~2f)~n', [Deporte, Distancia]),
    imprimir_recomendaciones(Resto).
```

**Funcionamiento:**

1. **Caso base**: Lista vacía, no hace nada
2. **Caso recursivo**:
   - Imprime el primer deporte con su distancia
   - Llama recursivamente para el resto de la lista

**Ejemplo de salida:**

```
--- DEPORTES RECOMENDADOS (Top 10 más cercanos) ---
  - Baloncesto, point guard (Distancia: 0.21)
  - Fútbol (Soccer) (Distancia: 0.64)
  - Fútbol, mediocampista (Distancia: 0.72)
  - Medio maratón, 21 km (Distancia: 0.95)
  - Balonmano (Handball) (Distancia: 1.10)
  - Karate (Distancia: 1.15)
  - Sprint (Velocidad) (Distancia: 1.32)
  - Fútbol sala (Distancia: 1.40)
  - Atletismo, relevo 4 × 100 m (Distancia: 1.45)
  - Voleibol, colocador (setter) (Distancia: 1.52)
```

---

## Ejemplos Prácticos

### Ejemplo 1: Atleta Mesomorfo (Musculoso)

**Entrada:**
```
Peso: 80 kg
Estatura: 180 cm
Tríceps: 8 mm
Subescapular: 10 mm
Supraespinal: 7 mm
Pantorrilla: 6 mm
Húmero: 7.2 cm
Fémur: 10.0 cm
Brazo: 35 cm
Pantorrilla: 39 cm
Sexo: h
```

**Proceso de cálculo:**

1. **Endomorfia:**
   ```
   S3P = 8 + 10 + 7 = 25
   X = 25 × (170.18 / 180) = 23.63
   Endo = -0.7182 + (0.1451 × 23.63) - (0.00068 × 23.63²) + (0.0000014 × 23.63³)
   Endo ≈ 2.1
   ```

2. **Mesomorfia:**
   ```
   PBC = 35 - (8 / 10) = 34.2
   PPC = 39 - (6 / 10) = 38.4
   Meso = (0.858 × 7.2) + (0.601 × 10.0) + (0.188 × 34.2) + (0.161 × 38.4) - (0.131 × 180) + 4.50
   Meso ≈ 6.3
   ```

3. **Ectomorfia:**
   ```
   IP = 180 / ∛80 = 180 / 4.31 = 41.76
   Ecto = (0.732 × 41.76) - 28.58 = 2.0
   ```

4. **Coordenadas:**
   ```
   X = 2.0 - 2.1 = -0.1
   Y = (2 × 6.3) - (2.1 + 2.0) = 8.5
   ```

5. **Clasificación:** Mesomorfo Balanceado

6. **Deportes recomendados:**
   - Fútbol americano, running back
   - Béisbol
   - Rugby
   - Sprint 100 m
   - Baloncesto
   - Voleibol
   - Balonmano
   - Levantamiento de pesas
   - Judo
   - Lucha

---

### Ejemplo 2: Corredor Ectomorfo (Delgado)

**Entrada:**
```
Peso: 60 kg
Estatura: 178 cm
Tríceps: 5 mm
Subescapular: 7 mm
Supraespinal: 5 mm
Pantorrilla: 4 mm
Húmero: 6.0 cm
Fémur: 8.5 cm
Brazo: 27 cm
Pantorrilla: 33 cm
Sexo: h
```

**Proceso de cálculo:**

1. **Endomorfia:**
   ```
   S3P = 5 + 7 + 5 = 17
   X = 17 × (170.18 / 178) = 16.25
   Endo ≈ 1.6
   ```

2. **Mesomorfia:**
   ```
   PBC = 27 - (5 / 10) = 26.5
   PPC = 33 - (4 / 10) = 32.6
   Meso ≈ 3.8
   ```

3. **Ectomorfia:**
   ```
   IP = 178 / ∛60 = 178 / 3.91 = 45.52
   Ecto = (0.732 × 45.52) - 28.58 = 4.7
   ```

4. **Coordenadas:**
   ```
   X = 4.7 - 1.6 = 3.1
   Y = (2 × 3.8) - (1.6 + 4.7) = 1.3
   ```

5. **Clasificación:** Ectomorfo Balanceado

6. **Deportes recomendados:**
   - Marcha atlética
   - Atletismo, larga distancia
   - Medio maratón
   - Ciclismo de ruta
   - Triatlón
   - Sprint 400 m
   - Atletismo, media distancia
   - Salto de altura
   - Voleibol
   - Escalada deportiva

---

### Ejemplo 3: Powerlifter Endomorfo (Corpulento)

**Entrada:**
```
Peso: 110 kg
Estatura: 175 cm
Tríceps: 20 mm
Subescapular: 25 mm
Supraespinal: 22 mm
Pantorrilla: 18 mm
Húmero: 7.5 cm
Fémur: 11.0 cm
Brazo: 40 cm
Pantorrilla: 42 cm
Sexo: h
```

**Proceso de cálculo:**

1. **Endomorfia:**
   ```
   S3P = 20 + 25 + 22 = 67
   X = 67 × (170.18 / 175) = 65.16
   Endo ≈ 7.2
   ```

2. **Mesomorfia:**
   ```
   PBC = 40 - (20 / 10) = 38.0
   PPC = 42 - (18 / 10) = 40.2
   Meso ≈ 8.5
   ```

3. **Ectomorfia:**
   ```
   IP = 175 / ∛110 = 175 / 4.79 = 36.53
   Ecto = 0.1 (IP ≤ 38.25)
   ```

4. **Coordenadas:**
   ```
   X = 0.1 - 7.2 = -7.1
   Y = (2 × 8.5) - (7.2 + 0.1) = 9.8
   ```

5. **Clasificación:** Endomorfo-Mesomorfo

6. **Deportes recomendados:**
   - Powerlifting
   - Levantamiento de pesas
   - Lanzamiento de peso
   - Lanzamiento de martillo
   - Fútbol americano, linemen
   - Rugby, hooker
   - Lucha, categorías pesadas
   - Judo, categorías pesadas
   - Lanzamiento de disco
   - Rugby, pilar

---

## Conclusión

Este sistema proporciona una evaluación completa del somatotipo utilizando métodos científicamente validados y ofrece recomendaciones deportivas personalizadas basadas en perfiles de atletas profesionales.

### Ventajas del sistema:

✅ **Método científico**: Utiliza las ecuaciones de Heath-Carter
✅ **Base de datos extensa**: Más de 200 perfiles deportivos
✅ **Personalización**: Diferencia entre hombres y mujeres
✅ **Precisión**: Usa distancia euclidiana para matching
✅ **Interpretable**: Proporciona descripciones claras

### Limitaciones:

⚠️ Requiere mediciones precisas tomadas por profesionales
⚠️ No considera factores psicológicos o preferencias personales
⚠️ Es una guía orientativa, no un dictamen absoluto
⚠️ No reemplaza la evaluación de un entrenador deportivo

---

**Documento creado para el Sistema de Análisis de Somatotipo v1.0**
