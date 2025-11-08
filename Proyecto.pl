:- encoding(utf8).

% 1. Pedir ñas diez medidas
% 2. Calcular el valor de cada somatiopo

calcular_somatotipo :-
    obtener_medidas(Peso, Estatura, P_Tri, P_Sub, P_Sup, P_Pan, D_Hum, D_Fem, Per_Bra, Per_Pan),
    
    nl,
    write('--- RESULTADOS DEL SOMATOTIPO ---'), nl,
    
    % Calcula e imprime Endomorfia
    calcular_endomorfia(P_Tri, P_Sub, P_Sup, Estatura, Endo),
    format('1. Endomorfia: ~3f~n', [Endo]),
    
    % Calcula e imprime Mesomorfia
    calcular_mesomorfia(Estatura, P_Tri, P_Pan, D_Hum, D_Fem, Per_Bra, Per_Pan, Meso),
    format('2. Mesomorfia: ~3f~n', [Meso]),
    
    % Calcula e imprime Ectomorfia
    calcular_ectomorfia(Peso, Estatura, Ecto),
    format('3. Ectomorfia: ~3f~n', [Ecto]),
    
    % Calcula las coordenadas X e Y
    calcular_coordenadas(Endo, Meso, Ecto, X, Y),
    
    % Clasifica el tipo de cuerpo
    clasificar_tipo_cuerpo(Endo, Meso, Ecto, TipoCuerpo, Descripcion),
    
    nl, 
    format('========================================================================~n'),
    format('  Somatotipo final (Endo-Meso-Ecto): ~1f - ~1f - ~1f~n', [Endo, Meso, Ecto]),
    format('  Tipo de cuerpo: ~w~n', [TipoCuerpo]),
    format('  Descripción: ~w~n', [Descripcion]),
    format('  Coordenadas (X, Y): (~2f, ~2f)~n', [X, Y]),
    format('========================================================================~n'),
    
    % Pedir sexo del usuario
    nl,
    write('Ingrese su sexo (h para hombre, m para mujer): '),
    read(Sexo),
    
    % Recomendar deportes
    nl,
    write('--- DEPORTES RECOMENDADOS (Top 10 más cercanos) ---'), nl,
    recomendar_deportes(X, Y, Sexo, Deportes),
    imprimir_recomendaciones(Deportes),
    nl,
    format('========================================================================~n').



% Pide al usuario cada una de las 10 medidass.

obtener_medidas(Peso, Estatura, P_Tri, P_Sub, P_Sup, P_Pan, D_Hum, D_Fem, Per_Bra, Per_Pan) :-
    write('--- Ingrese las 10 mediciones antropométricas ---'), nl,
    write('NOTA: Ingrese números y termine cada uno con un PUNTO (.).'), nl,
    write('      (Ejemplo: 80. o 175.5.)'), nl, nl,
    
    preguntar('1. Peso (kg): ', Peso),
    preguntar('2. Estatura (cm): ', Estatura),
    preguntar('3. Pliegue Tríceps (mm): ', P_Tri),
    preguntar('4. Pliegue Subescapular (mm): ', P_Sub),
    preguntar('5. Pliegue Supraespinal (mm): ', P_Sup),
    preguntar('6. Pliegue Pantorrilla Medial (mm): ', P_Pan),
    preguntar('7. Diámetro Húmero (cm): ', D_Hum),
    preguntar('8. Diámetro Fémur (cm): ', D_Fem),
    preguntar('9. Perímetro Brazo Contraído (cm): ', Per_Bra),
    preguntar('10. Perímetro Pantorrilla (cm): ', Per_Pan).

% Para preguntar y leer un valor
preguntar(Prompt, Valor) :-
    write(Prompt),
    read(Valor).


% Cálculo de Endomorfia
calcular_endomorfia(P_Tri, P_Sub, P_Sup, Estatura, Endo) :-
    S3P is P_Tri + P_Sub + P_Sup,
    X is S3P * (170.18 / Estatura),
    % Fórmula Endo = -0.7182 + (0.1451 * X) - (0.00068 * X^2) + (0.0000014 * X^3)
    Endo is -0.7182 + (0.1451 * X) - (0.00068 * X**2) + (0.0000014 * X**3).

% Cálculo de Mesomorfia
calcular_mesomorfia(Estatura, P_Tri, P_Pan, D_Hum, D_Fem, Per_Bra, Per_Pan, Meso) :-
    % Corregir perímetros (Pliegues de mm a cm)
    PBC is Per_Bra - (P_Tri / 10),
    PPC is Per_Pan - (P_Pan / 10),
    
    % Fórmula final
    Meso is (0.858 * D_Hum) + (0.601 * D_Fem) + (0.188 * PBC) + (0.161 * PPC) - (0.131 * Estatura) + 4.50.

% Cálculo de Ectomorfia
calcular_ectomorfia(Peso, Estatura, Ecto) :-
    % Calcular Índice Ponderal (IP)
    IP is Estatura / (Peso**(1/3)),
    
    % Fórmulas condicionales
    (   IP >= 40.75
    ->  % Si IP es >= 40.75
        Ecto is (0.732 * IP) - 28.58
    ;   % Else if (IP < 40.75 & IP > 38.25)
        IP < 40.75, IP > 38.25
    ->  Ecto is (0.463 * IP) - 17.63
    ;   % Else (IP <= 38.25)
        Ecto is 0.1
    ).

% Calcula las coordenadas X e Y del somatotipo
% calcular_coordenadas(+Endo, +Meso, +Ecto, -X, -Y)
calcular_coordenadas(Endo, Meso, Ecto, X, Y) :-
    X is Ecto - Endo,
    Y is (2 * Meso) - (Endo + Ecto).

% Clasifica el tipo de cuerpo según el somatotipo
% clasificar_tipo_cuerpo(+Endo, +Meso, +Ecto, -TipoCuerpo, -Descripcion)
clasificar_tipo_cuerpo(Endo, Meso, Ecto, TipoCuerpo, Descripcion) :-
    % Calcular diferencias
    DifEM is abs(Endo - Meso),
    DifEO is abs(Endo - Ecto),
    DifMO is abs(Meso - Ecto),
    
    % 1. Primero verificar CENTRAL (todos son casi iguales)
    (   DifEM =< 0.5, DifEO =< 0.5, DifMO =< 0.5
    ->  TipoCuerpo = 'Central',
        Descripcion = 'Proporciones equilibradas en todos los componentes.'
    
    % 2. Verificar COMBINACIONES BALANCEADAS (dos componentes dominantes y casi iguales)
    ;   DifEM =< 0.5, Endo > Ecto, Meso > Ecto
    ->  TipoCuerpo = 'Endomorfo-Mesomorfo',
        Descripcion = 'Musculoso y redondo. Una combinación robusta donde el músculo y la grasa son altos. Físico fuerte y corpulento, con el componente muscular siendo ligeramente mayor.'
    
    ;   DifMO =< 0.5, Meso > Endo, Ecto > Endo
    ->  TipoCuerpo = 'Meso-Ectomorfo',
        Descripcion = 'Musculoso y esbelto. Mucha musculatura combinada con linealidad y poca grasa. Físico fuerte, fibroso y alargado.'
    
    ;   DifEO =< 0.5, Endo > Meso, Ecto > Meso
    ->  TipoCuerpo = 'Ectomorfo-Endomorfo',
        Descripcion = 'Linealidad y adiposidad son similares. A menudo, un físico delgado con notable acumulación de grasa (delgado-gordo o skinny fat).'
    
    % 3. DOMINANCIA ENDOMORFA (E es el más alto)
    ;   Endo > Meso, Endo > Ecto
    ->  (   DifMO =< 0.5
        ->  TipoCuerpo = 'Endomorfo Balanceado',
            Descripcion = 'Físico redondeado y suave (Grasa dominante), con alta y simétrica acumulación de adiposidad en todo el cuerpo.'
        ;   Meso > Ecto
        ->  TipoCuerpo = 'Endo-Mesomórfico',
            Descripcion = 'Corpulento con base muscular. Gran desarrollo de grasa y músculo (ambos altos). Físico grande, fuerte y de formas redondeadas.'
        ;   TipoCuerpo = 'Endo-Ectomórfico',
            Descripcion = 'Redondeado, pero con estructura lineal. Tendencia a la acumulación de grasa (dominante), pero con extremidades más largas y esbeltas.'
        )
    
    % 4. DOMINANCIA MESOMORFA (M es el más alto)
    ;   Meso > Endo, Meso > Ecto
    ->  (   DifEO =< 0.5
        ->  TipoCuerpo = 'Mesomorfo Balanceado',
            Descripcion = 'Alto desarrollo muscular y óseo (Músculo dominante), con proporciones simétricas y baja grasa. El físico atlético ideal.'
        ;   Endo > Ecto
        ->  TipoCuerpo = 'Meso-Endomórfico',
            Descripcion = 'Fuerte con tendencia a la corpulencia. Mucha musculatura (dominante), pero con acumulación de grasa moderada. Físico robusto y ancho.'
        ;   TipoCuerpo = 'Meso-Ectomórfico',
            Descripcion = 'Delgado (linealidad dominante), pero con buen desarrollo muscular relativo. Físico fibroso, de extremidades largas.'
        )
    
    % 5. DOMINANCIA ECTOMORFA (O es el más alto)
    ;   Ecto > Endo, Ecto > Meso
    ->  (   DifEM =< 0.5
        ->  TipoCuerpo = 'Ectomorfo Balanceado',
            Descripcion = 'Muy delgado y lineal (Delgadez dominante). Extremidades largas, hombros estrechos y muy poca masa muscular o grasa.'
        ;   Endo > Meso
        ->  TipoCuerpo = 'Ecto-Endomórfico',
            Descripcion = 'Delgado y suave. Mantiene la linealidad pero con una ligera tendencia a la acumulación de grasa y formas suaves.'
        ;   TipoCuerpo = 'Ecto-Mesomórfico',
            Descripcion = 'Musculoso y esbelto. Mucha musculatura combinada con linealidad y poca grasa. Físico fuerte, fibroso y alargado.'
        )
    
    % Fallback (no debería llegar aquí)
    ;   TipoCuerpo = 'No clasificado',
        Descripcion = 'No se pudo clasificar el somatotipo.'
    ).

% Encuentra los 10 deportes más cercanos según distancia euclidiana
% recomendar_deportes(+X, +Y, +Sexo, -ListaDeportes)
% Sexo debe ser 'h' (hombre) o 'm' (mujer)
recomendar_deportes(X, Y, Sexo, ListaDeportes) :-
    % Obtener todos los deportes con sus distancias
    findall(
        distancia(Distancia, Deporte),
        (
            % Seleccionar base de datos según sexo
            (Sexo = h -> deporteH(Deporte, XDeporte, YDeporte) ; deporteM(Deporte, XDeporte, YDeporte)),
            % Calcular distancia euclidiana
            Distancia is sqrt((X - XDeporte)**2 + (Y - YDeporte)**2)
        ),
        Distancias
    ),
    % Ordenar por distancia (menor a mayor)
    sort(Distancias, DistanciasOrdenadas),
    % Tomar los primeros 10
    tomar_primeros_10(DistanciasOrdenadas, Top10),
    % Extraer solo los nombres de los deportes
    extraer_deportes(Top10, ListaDeportes).

% Toma los primeros 10 elementos de una lista
tomar_primeros_10(Lista, Resultado) :-
    length(Prefijo, 10),
    append(Prefijo, _, Lista),
    !,
    Resultado = Prefijo.
tomar_primeros_10(Lista, Lista).  % Si hay menos de 10, devolver todos

% Extrae los nombres de deportes de la lista de distancias
extraer_deportes([], []).
extraer_deportes([distancia(Dist, Deporte)|Resto], [resultado(Deporte, Dist)|RestoDeportes]) :-
    extraer_deportes(Resto, RestoDeportes).

% Imprime la lista de deportes recomendados de forma legible
imprimir_recomendaciones([]).
imprimir_recomendaciones([resultado(Deporte, Distancia)|Resto]) :-
    format('  - ~w (Distancia: ~2f)~n', [Deporte, Distancia]),
    imprimir_recomendaciones(Resto).



%------------------------------------------------------------------------------------------------------------------------------------------------
% DATOS
%------------------------------------------------------------------------------------------------------------------------------------------------
% Base de conocimiento de deportes Hombres
% Formato: deporte(Nombre, X, Y).

deporteH('Fútbol americano, defensive back', 0.6, 3.6).
deporteH('Fútbol americano, defensive end', -4.2, 8.4).
deporteH('Fútbol americano, linemen', -3.0, 7.6).
deporteH('Fútbol americano, linebacker', -3.6, 8.8).
deporteH('Fútbol americano, quarterback', -2.0, 7.8).
deporteH('Fútbol americano, running back', -2.4, 10.0).
deporteH('Fútbol americano, safety', -3.6, 5.4).
deporteH('Fútbol americano, wide receiver', -1.6, 6.8).
deporteH('Tiro con arco', -2.5, 7.9).
deporteH('Béisbol', -1.8, 8.6).
deporteH('Béisbol, catcher', -3.3, 5.9).
deporteH('Béisbol, center fielder', 1.1, 4.9).
deporteH('Béisbol, infielder', 1.8, 4.4).
deporteH('Béisbol, pitcher', -1.5, 3.7).
deporteH('Béisbol, second baseman', -1.6, 8.6).
deporteH('Baloncesto', -0.3, 5.3).
deporteH('Baloncesto, center', 1.3, 3.7).
deporteH('Baloncesto, forward', 0.7, 3.5).
deporteH('Baloncesto, point guard', 0.2, 5.4).
deporteH('Voleibol de playa', 0.3, 2.1).
deporteH('Boxeo', -0.9, 6.3).
deporteH('Boxeo < 63 kg', 1.1, 3.9).
deporteH('Boxeo < 69 kg', 0.3, 4.7).
deporteH('Boxeo < 75 kg', -1.8, 6.8).
deporteH('Boxeo > 91 kg', -3.3, 6.7).
deporteH('Esgrima, espada (épée)', -0.4, 1.4).
deporteH('Esgrima, florete (foil)', -0.6, 4.0).
deporteH('Fútbol bandera (Flag football)', -0.7, 4.7).
deporteH('Lucha libre', -3.1, 6.7).
deporteH('Lucha libre < 74 kg', -2.2, 8.6).
deporteH('Lucha grecorromana', -1.3, 6.7).
deporteH('Lucha grecorromana < 60 kg', -1.1, 7.9).
deporteH('Lucha grecorromana < 63 kg', 0.0, 7.6).
deporteH('Lucha grecorromana < 82 kg', -3.6, 9.6).
deporteH('Gimnasia', -0.1, 8.1).
deporteH('Medio maratón, 21 km', 0.2, 4.2).
deporteH('Balonmano (Handball)', -1.1, 7.3).
deporteH('Balonmano, lateral (back)', -1.9, 8.1).
deporteH('Balonmano, central (center)', -1.2, 6.4).
deporteH('Balonmano, portero (goalkeeper)', -1.3, 4.5).
deporteH('Balonmano, lateral izquierdo', 1.0, 4.0).
deporteH('Balonmano, extremo izquierdo', -0.9, 11.7).
deporteH('Balonmano, pivote (line player)', -4.2, 12.6).
deporteH('Balonmano, lateral derecho', -2.0, 7.2).
deporteH('Balonmano, extremo derecho', -0.4, 5.0).
deporteH('Balonmano, extremo (wing)', -1.1, 10.7).
deporteH('Salto de altura', 0.8, 2.8).
deporteH('Fútbol sala', -1.7, 5.3).
deporteH('Fútbol sala, defensor', -2.1, 4.5).
deporteH('Fútbol sala, delantero', -3.1, 6.5).
deporteH('Fútbol sala, portero', -1.1, 2.3).
deporteH('Fútbol sala, mediocampista', -1.7, 5.9).
deporteH('Lanzamiento de jabalina', -1.1, 8.5).
deporteH('Judo', -1.0, 6.6).
deporteH('Judo < 100 kg', -5.4, 12.0).
deporteH('Judo < 55 kg', 0.7, 2.7).
deporteH('Judo < 73 kg', -3.9, 6.1).
deporteH('Judo < 81 kg', -3.1, 12.9).
deporteH('Karate', 0.0, 3.4).
deporteH('Karate, kata', 0.6, 5.8).
deporteH('Karate, kumite', -1.0, 4.4).
deporteH('Kickboxing, low kick', 0.1, 3.5).
deporteH('Kickboxing, point fighting', -2.9, 4.9).
deporteH('Salto de longitud', -0.4, 6.0).
deporteH('Lucha olímpica', -1.7, 7.1).
deporteH('Lucha olímpica < 65 kg', -1.3, 5.9).
deporteH('Pádel', -1.4, 3.0).
deporteH('Pádel, dobles', -2.4, 5.8).
deporteH('Pentatlón', 1.7, 4.9).
deporteH('Powerlifting < 90 kg', -4.1, 7.7).
deporteH('Powerlifting < 125 kg', -5.5, 14.7).
deporteH('Powerlifting < 100 kg', -6.2, 11.0).
deporteH('Powerlifting < 140 kg', -7.2, 7.6).
deporteH('Marcha atlética (Racewalking)', 0.9, 2.3).
deporteH('Rugby', -2.3, 8.1).
deporteH('Rugby, center', -2.1, 7.3).
deporteH('Rugby, apertura (fly-half)', -0.3, 2.9).
deporteH('Rugby, hooker', -3.4, 13.6).
deporteH('Rugby, pilar (prop)', -1.9, 10.1).
deporteH('Rugby, medio scrum (scrum-half)', 1.3, 3.7).
deporteH('Rugby, ala (wing)', 1.0, 7.8).
deporteH('Fútbol (Soccer)', -0.4, 5.6).
deporteH('Fútbol, defensor', -0.6, 7.0).
deporteH('Fútbol, delantero', -0.4, 6.0).
deporteH('Fútbol, portero', -2.9, 10.3).
deporteH('Fútbol, mediocampista', -0.1, 5.9).
deporteH('Escalada deportiva', 0.6, 3.8).
deporteH('Sprint (Velocidad)', 2.0, 4.2).
deporteH('Sprint, 100 m', -0.5, 9.1).
deporteH('Sprint, 200 m', 1.9, 4.9).
deporteH('Sprint, 300 m vallas', 2.6, 2.4).
deporteH('Sprint, 400 m', 1.1, 2.7).
deporteH('Tenis de mesa', -0.6, 2.8).
deporteH('Taekwondo', 0.4, 4.0).
deporteH('Taekwondo < 74 kg', -0.4, 5.2).
deporteH('Lazo por equipos (Team roping), talón', -3.0, 1.2).
deporteH('Atletismo, relevo 4 × 100 m', 0.1, 5.5).
deporteH('Atletismo, relevo 4 × 400 m', 1.6, 2.6).
deporteH('Atletismo, larga distancia', 2.0, 2.6).
deporteH('Atletismo, media distancia', 0.4, 7.2).
deporteH('Ciclismo de pista', -1.4, 6.8).
deporteH('Triatlón', -1.4, 4.2).
deporteH('Triple salto', 1.1, 5.1).
deporteH('Voleibol', 1.5, 1.5).
deporteH('Voleibol, central', 5.2, -5.0).
deporteH('Voleibol, líbero', -0.8, 7.6).
deporteH('Voleibol, bloqueador central', -0.8, 3.2).
deporteH('Voleibol, opuesto', 2.4, -2.2).
deporteH('Voleibol, atacante externo', -0.2, 8.4).
deporteH('Voleibol, colocador (setter)', -0.3, 7.5).
deporteH('Levantamiento de pesas (Weightlifting)', -3.0, 9.8).
deporteH('Levantamiento de pesas < 67 kg', -0.4, 7.0).
deporteH('Levantamiento de pesas < 81 kg', -2.3, 8.1).
deporteH('Levantamiento de pesas < 89 kg', -4.1, 13.5).


% Base de conocimiento de deportes Mujeres
% Formato: deporte(Nombre, X, Y).

deporteM('Gimnasia aeróbica', -1.7, 4.5).
deporteM('Fútbol americano, left guard', -7.8, 5.2).
deporteM('Fútbol americano, quarterback', 0.1, 2.7).
deporteM('Tiro con arco', 1.9, -1.5).
deporteM('Baloncesto', -1.4, 1.0).
deporteM('Baloncesto, center', -1.9, -2.3).
deporteM('Baloncesto, forward (ala)', -2.0, 2.8).
deporteM('Baloncesto, point guard (base)', -1.6, 1.6).
deporteM('Voleibol de playa', -1.3, 0.5).
deporteM('Voleibol de playa, jugador completo', -3.8, 2.4).
deporteM('Voleibol de playa, bloqueador', -1.1, 0.1).
deporteM('Voleibol de playa, defensor', -2.5, -0.5).
deporteM('Boxeo', -3.1, 1.9).
deporteM('Lanzamiento de disco', -5.1, 7.5).
deporteM('Esgrima, florete', -4.8, 1.8).
deporteM('Esgrima, sable', -2.0, 0.4).
deporteM('Esgrima, espada', -1.6, -3.8).
deporteM('Fútbol bandera (Flag football)', -2.3, 2.7).
deporteM('Fútbol bandera, cornerback', 0.3, 0.5).
deporteM('Fútbol bandera, quarterback', -4.3, 3.3).
deporteM('Fútbol bandera, safety', -4.4, 7.4).
deporteM('Fútbol bandera, wide receiver', -3.0, 4.6).
deporteM('Gimnasia', -2.1, 4.5).
deporteM('Medio maratón, 21 km', -0.3, 0.5).
deporteM('Lanzamiento de martillo', -8.7, 8.3).
deporteM('Balonmano', -3.3, 3.5).
deporteM('Balonmano, lateral', -2.5, 2.9).
deporteM('Balonmano, central', -3.9, 4.9).
deporteM('Balonmano, portero', -4.7, 0.7).
deporteM('Balonmano, lateral', -2.7, 6.3).
deporteM('Balonmano, lateral izquierdo', -3.3, 4.3).
deporteM('Balonmano, extremo izquierdo', -4.3, 4.5).
deporteM('Balonmano, pivote', -5.4, 8.8).
deporteM('Balonmano, extremo derecho', -3.0, 3.4).
deporteM('Balonmano, extremo', -4.3, 3.7).
deporteM('Heptatlón', -0.8, 3.6).
deporteM('Fútbol sala', -2.9, 2.3).
deporteM('Fútbol sala, defensor', -1.9, 1.5).
deporteM('Fútbol sala, delantero', -1.1, 1.3).
deporteM('Fútbol sala, portero', -5.1, 3.1).
deporteM('Fútbol sala, mediocampista', -3.3, 1.9).
deporteM('Lanzamiento de jabalina', -4.7, 6.3).
deporteM('Judo', -0.8, 3.0).
deporteM('Judo <44 kg', -3.7, 2.3).
deporteM('Judo <48 kg', -21.6, -16.2).
deporteM('Judo <57 kg', -1.2, 3.0).
deporteM('Karate', -3.4, 2.2).
deporteM('Karate, kata', -1.3, 0.1).
deporteM('Karate, kumite', -3.0, 3.4).
deporteM('Kickboxing, low kick', -2.3, -0.1).
deporteM('Salto de longitud', -0.5, -0.1).
deporteM('Lucha olímpica', -3.0, 3.8).
deporteM('Lucha olímpica <53 kg', -1.0, 4.2).
deporteM('Pádel, dobles, jugador de revés', -3.6, 5.4).
deporteM('Pádel, dobles, jugador diestro', -0.9, 0.7).
deporteM('Salto con pértiga', -0.7, 5.1).
deporteM('Powerlifting <44 kg', 0.2, -3.0).
deporteM('Powerlifting <90 kg', -7.4, 5.6).
deporteM('Marcha atlética, 20 km', -2.5, -1.9).
deporteM('Ciclismo de ruta', 1.7, 1.5).
deporteM('Rugby', -3.4, 2.2).
deporteM('Rugby 7s, pilar', -4.9, 4.3).
deporteM('Rugby, centro', -3.2, 1.6).
deporteM('Rugby, primera línea', -4.5, 8.1).
deporteM('Rugby, primer centro', -1.2, 2.2).
deporteM('Rugby, pilar', -3.6, 4.2).
deporteM('Rugby, medio scrum', -3.0, 2.2).
deporteM('Rugby, ala', -1.0, 1.0).
deporteM('Lanzamiento de peso', -4.6, 10.6).
deporteM('Fútbol', -2.0, 2.8).
deporteM('Fútbol, defensor', -1.4, 1.0).
deporteM('Fútbol, delantero', -2.1, 2.1).
deporteM('Fútbol, portero', -4.1, 2.5).
deporteM('Fútbol, mediocampista', -1.1, 2.5).
deporteM('Sóftbol', -2.6, 1.6).
deporteM('Sóftbol, jardinero (fielder)', -2.4, 0.4).
deporteM('Sóftbol, segunda base', -1.0, 2.2).
deporteM('Sóftbol, campocorto (shortstop)', -2.3, 3.1).
deporteM('Escalada deportiva', 0.0, -0.8).
deporteM('Sprint (Velocidad)', 0.1, 1.5).
deporteM('Sprint, 100 m', -1.3, 1.3).
deporteM('Sprint, 200 m', -1.8, 1.4).
deporteM('Sprint, 400 m', 0.2, -0.6).
deporteM('Sprint, 400 m vallas', -1.2, 5.2).
deporteM('Tenis de mesa', -2.5, 1.1).
deporteM('Taekwondo', -1.8, 1.0).
deporteM('Taekwondo <46 kg', 1.6, -2.4).
deporteM('Taekwondo <49 kg', 1.1, -1.3).
deporteM('Atletismo, larga distancia', -1.8, 0.4).
deporteM('Atletismo, media distancia', -1.2, 2.6).
deporteM('Atletismo, 1500 m', -1.8, -0.4).
deporteM('Atletismo, 10,000 m', -1.7, 0.5).
deporteM('Atletismo, 3000 m obstáculos', -0.3, 3.9).
deporteM('Atletismo, relevo 4x100 m', -1.2, 2.8).
deporteM('Atletismo, 5000 m', -0.1, 4.5).
deporteM('Atletismo, 800 m', -1.0, 3.2).
deporteM('Ciclismo de pista', -1.0, 6.0).
deporteM('Triatlón', -2.6, 2.0).
deporteM('Voleibol', -2.1, 0.7).
deporteM('Voleibol, central', -2.9, -2.7).
deporteM('Voleibol, atacante externo', -5.0, 5.8).
deporteM('Voleibol, colocador', -1.6, 4.8).
deporteM('Levantamiento de pesas', -2.3, 4.5).
deporteM('Levantamiento de pesas <45 kg', 0.6, 4.2).
deporteM('Levantamiento de pesas <55 kg', -2.8, 6.0).
deporteM('Levantamiento de pesas <59 kg', -5.0, 8.2).
deporteM('Levantamiento de pesas <64 kg', -5.6, 6.4).
deporteM('Sprint, 400 m vallas', -1.2, 5.2).
deporteM('Tenis de mesa', -2.5, 1.1).
deporteM('Taekwondo', -1.8, 1.0).
deporteM('Taekwondo <46 kg', 1.6, -2.4).
deporteM('Taekwondo <49 kg', 1.1, -1.3).
deporteM('Atletismo, larga distancia', -1.8, 0.4).
deporteM('Atletismo, media distancia', -1.2, 2.6).
deporteM('Atletismo, 1500 m', -1.8, -0.4).
deporteM('Atletismo, 10,000 m', -1.7, 0.5).
deporteM('Atletismo, 3000 m obstáculos', -0.3, 3.9).
deporteM('Atletismo, relevo 4x100 m', -1.2, 2.8).
deporteM('Atletismo, 5000 m', -0.1, 4.5).
deporteM('Atletismo, 800 m', -1.0, 3.2).
deporteM('Ciclismo de pista', -1.0, 6.0).
deporteM('Triatlón', -2.6, 2.0).
deporteM('Voleibol', -2.1, 0.7).
deporteM('Voleibol, central', -2.9, -2.7).
deporteM('Voleibol, atacante externo', -5.0, 5.8).
deporteM('Voleibol, colocador', -1.6, 4.8).
deporteM('Levantamiento de pesas', -2.3, 4.5).
deporteM('Levantamiento de pesas <45 kg', 0.6, 4.2).
deporteM('Levantamiento de pesas <55 kg', -2.8, 6.0).
deporteM('Levantamiento de pesas <59 kg', -5.0, 8.2).
deporteM('Levantamiento de pesas <64 kg', -5.6, 6.4).
