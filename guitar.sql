CREATE OR REPLACE PACKAGE PK_SOUNDS AS
    C CONSTANT VARCHAR(1) := 'C';
    CISZ CONSTANT VARCHAR(2) := 'C#';
    D CONSTANT VARCHAR(1) := 'D';
    DISZ CONSTANT VARCHAR(2) := 'D#';
    E CONSTANT VARCHAR(1) := 'E';
    F CONSTANT VARCHAR(1) := 'F';
    FISZ CONSTANT VARCHAR(2) := 'F#';
    G CONSTANT VARCHAR(1) := 'G';
    GISZ CONSTANT VARCHAR(2) := 'G#';
    A CONSTANT VARCHAR(1) := 'A';
    AISZ CONSTANT VARCHAR(2) := 'A#';
    B CONSTANT VARCHAR(1) := 'B';

END PK_SOUNDS;
/

CREATE OR REPLACE PUBLIC SYNONYM PK_SOUNDS FOR GUITAR.PK_SOUNDS;
/

CREATE OR REPLACE TYPE GUITAR.SOUND AS OBJECT (
    V_SOUND VARCHAR(2),
    V_OCTAVE NUMBER(1),
    CONSTRUCTOR FUNCTION SOUND(sound IN VARCHAR2, octave IN NUMBER) RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY GUITAR.SOUND IS
    CONSTRUCTOR FUNCTION SOUND(sound IN VARCHAR2, octave IN NUMBER) RETURN SELF AS RESULT IS
    BEGIN
        SELF.V_SOUND := sound;
        SELF.V_OCTAVE := octave;
    END;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM SOUND FOR GUITAR.SOUND;
/

