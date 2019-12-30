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
    
    FUNCTION get_sound_name(sound PLS_INTEGER) RETURN VARCHAR2;

    FUNCTION get_num_of_sounds RETURN PLS_INTEGER;
END PK_SOUNDS;
/

CREATE OR REPLACE PACKAGE BODY GUITAR.PK_SOUNDS IS
    TYPE T_SOUND_NAMES IS TABLE OF VARCHAR2(2) INDEX BY PLS_INTEGER;
    
    FUNCTION init_t_sound_names RETURN T_SOUND_NAMES;
    
    v_sound_names T_SOUND_NAMES := init_t_sound_names();
    
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
    
    FUNCTION get_sound_name(sound PLS_INTEGER) RETURN VARCHAR2 IS
    BEGIN
        RETURN v_sound_names(sound);
    END;

    FUNCTION get_num_of_sounds RETURN PLS_INTEGER IS
    BEGIN
        RETURN v_sound_names.count;
    END;

END PK_SOUNDS;
/

CREATE OR REPLACE PUBLIC SYNONYM PK_SOUNDS FOR GUITAR.PK_SOUNDS;
/

CREATE OR REPLACE TYPE GUITAR.SOUND AS OBJECT (
    V_SOUND NUMBER(2),
    V_OCTAVE NUMBER(1),
    CONSTRUCTOR FUNCTION SOUND(sound IN NUMBER, octave IN NUMBER) RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY GUITAR.SOUND IS
    CONSTRUCTOR FUNCTION SOUND(sound IN NUMBER, octave IN NUMBER) RETURN SELF AS RESULT IS
    BEGIN
        SELF.V_SOUND := sound;
        SELF.V_OCTAVE := octave;
        RETURN;
    END;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM SOUND FOR GUITAR.SOUND;
/

