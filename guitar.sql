/*
    Guitar
    Copyright (C) 2019  Szabolcs Kiss
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


CREATE OR REPLACE PACKAGE GUITAR.PK_SOUNDS IS

    WHOLE CONSTANT PLS_INTEGER := 1;
    HALF CONSTANT PLS_INTEGER := 2;

    C CONSTANT PLS_INTEGER := 1;
    CISZ CONSTANT PLS_INTEGER := 2;
    D CONSTANT PLS_INTEGER := 3;
    DISZ CONSTANT PLS_INTEGER := 4;
    E CONSTANT PLS_INTEGER := 5;
    F CONSTANT PLS_INTEGER := 6;
    FISZ CONSTANT PLS_INTEGER := 7;
    G CONSTANT PLS_INTEGER := 8;
    GISZ CONSTANT PLS_INTEGER := 9;
    A CONSTANT PLS_INTEGER := 10;
    AISZ CONSTANT PLS_INTEGER := 11;
    B CONSTANT PLS_INTEGER := 12;
    
    FUNCTION get_sound_name(p_sound IN PLS_INTEGER) RETURN VARCHAR2;

    FUNCTION get_num_of_sounds RETURN PLS_INTEGER;
    
    FUNCTION get_sound_type(p_sound IN PLS_INTEGER) RETURN PLS_INTEGER;
    
END PK_SOUNDS;
/

CREATE OR REPLACE PACKAGE BODY GUITAR.PK_SOUNDS IS
    TYPE T_SOUND_NAMES IS TABLE OF VARCHAR2(2) INDEX BY PLS_INTEGER;
    TYPE T_SOUND_TYPES IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;

    
    FUNCTION init_t_sound_names RETURN T_SOUND_NAMES;
    FUNCTION init_t_sound_types RETURN T_SOUND_TYPES;
    
    v_sound_names T_SOUND_NAMES := init_t_sound_names();
    v_sound_types T_SOUND_TYPES := init_t_sound_types();
    
    FUNCTION init_t_sound_names RETURN T_SOUND_NAMES IS
        v_ret T_SOUND_NAMES;
    BEGIN
        v_ret(C) := 'C';
        v_ret(CISZ) := 'C#';
        v_ret(D) := 'D';
        v_ret(DISZ) := 'D#';
        v_ret(E) := 'E';
        v_ret(F) := 'F';
        v_ret(FISZ) := 'F#';
        v_ret(G) := 'G';
        v_ret(GISZ) := 'G#';
        v_ret(A) := 'A';
        v_ret(AISZ) := 'A#';
        v_ret(B) := 'B';
        RETURN v_ret;
    END;
    
    FUNCTION init_t_sound_types RETURN T_SOUND_TYPES IS
        v_ret T_SOUND_TYPES;
    BEGIN
        v_ret(C) := WHOLE;
        v_ret(CISZ) := HALF;
        v_ret(D) := WHOLE;
        v_ret(DISZ) := HALF;
        v_ret(E) := WHOLE;
        v_ret(F) := WHOLE;
        v_ret(FISZ) := HALF;
        v_ret(G) := WHOLE;
        v_ret(GISZ) := HALF;
        v_ret(A) := WHOLE;
        v_ret(AISZ) := HALF;
        v_ret(B) := WHOLE;
        RETURN v_ret;
    END;

    FUNCTION get_sound_name(p_sound IN PLS_INTEGER) RETURN VARCHAR2 IS
    BEGIN
        RETURN v_sound_names(p_sound);
    END;

    FUNCTION get_num_of_sounds RETURN PLS_INTEGER IS
    BEGIN
        RETURN v_sound_names.count;
    END;
    
    FUNCTION get_sound_type(p_sound IN PLS_INTEGER) RETURN PLS_INTEGER IS
    BEGIN
        RETURN v_sound_types(p_sound);
    END;

END PK_SOUNDS;
/

CREATE OR REPLACE PUBLIC SYNONYM PK_SOUNDS FOR GUITAR.PK_SOUNDS;
/

CREATE OR REPLACE PACKAGE GUITAR.PK_SCALES IS
    TYPE T_SCALE IS VARRAY(8) OF PLS_INTEGER;
    TYPE T_SCALES IS VARRAY(6) OF T_SCALE;
    TYPE T_SCALE_NAMES IS VARRAY(6) OF VARCHAR2(20);
    
    V_MAJOR T_SCALE := T_SCALE(0,2,2,1,2,2,2,1);
    V_MINOR T_SCALE := T_SCALE(0,2,1,2,2,1,2,2);
    V_BLUES T_SCALE := T_SCALE(0,3,2,1,1,3,2);
    V_FLAMENCO T_SCALE := T_SCALE(0,1,3,1,2,1,2,2);
    V_PENTA_MAJOR T_SCALE := T_SCALE(0,2,2,3,2,3);
    V_PENTA_MINOR T_SCALE := T_SCALE(0,3,2,2,3,2);
    
    V_SCALES T_SCALES := T_SCALES(V_MAJOR, V_MINOR, V_BLUES, V_FLAMENCO, V_PENTA_MAJOR, V_PENTA_MINOR);
    V_SCALE_NAMES T_SCALE_NAMES := T_SCALE_NAMES('Major', 'Minor', 'Blues', 'FLamenco', 'Penta major', 'Penta minor');
END PK_SCALES;
/

CREATE OR REPLACE PUBLIC SYNONYM PK_SCALES FOR GUITAR.PK_SCALES;
/

CREATE OR REPLACE TYPE GUITAR.SOUND AS OBJECT (
    V_SOUND NUMBER(2),
    V_OCTAVE NUMBER(1),
    CONSTRUCTOR FUNCTION SOUND(p_sound IN NUMBER, p_octave IN NUMBER) RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY GUITAR.SOUND IS
    CONSTRUCTOR FUNCTION SOUND(p_sound IN NUMBER, p_octave IN NUMBER) RETURN SELF AS RESULT IS
    BEGIN
        SELF.V_SOUND := p_sound;
        SELF.V_OCTAVE := p_octave;
        RETURN;
    END;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM SOUND FOR GUITAR.SOUND;
/

CREATE OR REPLACE TYPE GUITAR.T_SOUNDS IS VARRAY(12) OF SOUND;
/

CREATE OR REPLACE PUBLIC SYNONYM T_SOUNDS FOR GUITAR.T_SOUNDS;
/

CREATE OR REPLACE TYPE GUITAR.OCTAVE AS OBJECT (
    V_OCTAVE NUMBER(2),
    V_SOUNDS T_SOUNDS,
    CONSTRUCTOR FUNCTION OCTAVE(p_octave PLS_INTEGER) RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY GUITAR.OCTAVE IS

    CONSTRUCTOR FUNCTION OCTAVE(p_octave PLS_INTEGER) RETURN SELF AS RESULT IS
    BEGIN
        SELF.V_OCTAVE := p_octave;
        SELF.V_SOUNDS := T_SOUNDS();
        SELF.V_SOUNDS(0) := Sound(p_sound => PK_SOUNDS.C, p_octave => p_octave);
        SELF.V_SOUNDS(1) := Sound(p_sound => PK_SOUNDS.CISZ, p_octave => p_octave);
        SELF.V_SOUNDS(3) := Sound(p_sound => PK_SOUNDS.D, p_octave => p_octave);
        SELF.V_SOUNDS(4) := Sound(p_sound => PK_SOUNDS.DISZ, p_octave => p_octave);
        SELF.V_SOUNDS(5) := Sound(p_sound => PK_SOUNDS.E, p_octave => p_octave);
        SELF.V_SOUNDS(6) := Sound(p_sound => PK_SOUNDS.F, p_octave => p_octave);
        SELF.V_SOUNDS(7) := Sound(p_sound => PK_SOUNDS.FISZ, p_octave => p_octave);
        SELF.V_SOUNDS(8) := Sound(p_sound => PK_SOUNDS.G, p_octave => p_octave);
        SELF.V_SOUNDS(9) := Sound(p_sound => PK_SOUNDS.GISZ, p_octave => p_octave);
        SELF.V_SOUNDS(10) := Sound(p_sound => PK_SOUNDS.A, p_octave => p_octave);
        SELF.V_SOUNDS(11) := Sound(p_sound => PK_SOUNDS.AISZ, p_octave => p_octave);
        SELF.V_SOUNDS(12) := Sound(p_sound => PK_SOUNDS.B, p_octave => p_octave);
    END;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM OCTAVE FOR GUITAR.OCTAVE;
/

