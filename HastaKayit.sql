--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hastaneler; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hastaneler;


ALTER SCHEMA hastaneler OWNER TO postgres;

--
-- Name: bolumgetir(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bolumgetir(hastane integer) RETURNS TABLE(ad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT  "bolumadi" FROM "hastaneler"."acilanbolumler" WHERE "hastanekodu"=hastane;
END;
$$;


ALTER FUNCTION public.bolumgetir(hastane integer) OWNER TO postgres;

--
-- Name: boslukSil(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."boslukSil"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   
    NEW."hastaadi" = LTRIM(NEW."hastaadi"); 
    NEW."hastasoyadi" = LTRIM(NEW."hastasoyadi"); 
    RETURN NEW;
END;
$$;


ALTER FUNCTION public."boslukSil"() OWNER TO postgres;

--
-- Name: doktorgetir(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.doktorgetir(hastane integer, bolum character varying) RETURNS TABLE(ad character varying, soyad character varying, unvani character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

    RETURN QUERY SELECT  "docad","unvan","docsoyad" FROM "hastaneler"."doctorlar" WHERE "hastanesi"=hastane and "docbrans"=bolum;
END;
$$;


ALTER FUNCTION public.doktorgetir(hastane integer, bolum character varying) OWNER TO postgres;

--
-- Name: gecmis(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gecmis() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    hastaneID INT ;
BEGIN
    hastaneId :=  hastagecmisYardimci(CAST ( NEW."randid" as INTEGER)) ;
   Insert into "public"."hastagecmisi" ("hastaid","hastane","randevuid") Values (NEW."hastaid", hastaneId,NEW."randid");
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.gecmis() OWNER TO postgres;

--
-- Name: hastagecmisYardimci(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."hastagecmisYardimci"(hstid integer) RETURNS TABLE(id integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
 RETURN QUERY SELECT "rndhastane" FROM "public"."randevular" WHERE "rndid"=hstID;
 
END;
$$;


ALTER FUNCTION public."hastagecmisYardimci"(hstid integer) OWNER TO postgres;

--
-- Name: hastaneara(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hastaneara(sehir integer, ilce integer) RETURNS TABLE(ad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT  "adi" FROM "hastaneler"."Hastaneler"
                 WHERE "ilkodu" = sehir AND "ilcekodu" = ilce;
END;
$$;


ALTER FUNCTION public.hastaneara(sehir integer, ilce integer) OWNER TO postgres;

--
-- Name: hastanegetir(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hastanegetir() RETURNS TABLE(id integer, ad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "hastanekodu", "adi" FROM "hastaneler"."Hastaneler" ;
END;
$$;


ALTER FUNCTION public.hastanegetir() OWNER TO postgres;

--
-- Name: ilcegetir(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ilcegetir(il integer) RETURNS TABLE(ad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT  "ilceadi" FROM "hastaneler"."Ilceler" WHERE "ilkodu"=il;
END;
$$;


ALTER FUNCTION public.ilcegetir(il integer) OWNER TO postgres;

--
-- Name: ilcegetir2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ilcegetir2() RETURNS TABLE(ad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT  "ilceadi" FROM "hastaneler"."Ilceler" ;
END;
$$;


ALTER FUNCTION public.ilcegetir2() OWNER TO postgres;

--
-- Name: ilgetir(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ilgetir() RETURNS TABLE(ad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT  "adi" FROM "hastaneler"."Iller";
END;
$$;


ALTER FUNCTION public.ilgetir() OWNER TO postgres;

--
-- Name: kucukHarf(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."kucukHarf"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."hastaadi" = LOWER(NEW."hastaadi"); 
     NEW."hastasoyadi" = LOWER(NEW."hastasoyadi"); 
    RETURN NEW;
END;
$$;


ALTER FUNCTION public."kucukHarf"() OWNER TO postgres;

--
-- Name: randevuAl(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."randevuAl"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM public.acilanrandevular WHERE "rndid" IN (SELECT "randid" FROM "public"."randevularim" );
   RETURN NEW;
END;
$$;


ALTER FUNCTION public."randevuAl"() OWNER TO postgres;

--
-- Name: randevuOlustur(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."randevuOlustur"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 INSERT INTO "public"."acilanrandevular" SELECT "rndid","rndtarih" , "rndsaat","rndhastane" ,"rndbolum" ,"rnddoc"  FROM    "public"."randevular" WHERE "rndid" NOT IN(SELECT "rndid"  FROM "public"."acilanrandevular"  ) OR "rndid" NOT IN(SELECT "rndid"  FROM "public"."randevularim"  ) ;
   RETURN NEW;
END;
$$;


ALTER FUNCTION public."randevuOlustur"() OWNER TO postgres;

--
-- Name: randevuekle(character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.randevuekle(tarih character varying, saat character varying, hastane integer, bolum character varying, doc integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN

   INSERT INTO "public"."randevular" ("rndtarih","rndsaat","rndhastane","rndbolum","rnddoc") VALUES ($1,$2,$3,$4,$5);
END;
$_$;


ALTER FUNCTION public.randevuekle(tarih character varying, saat character varying, hastane integer, bolum character varying, doc integer) OWNER TO postgres;

--
-- Name: receteOlustur(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."receteOlustur"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 INSERT INTO "public"."ilaclarim" ("ilacadi","recetid","hastaid") VALUES (NEW."ilacadi",NEW."receteid",NEW."hastaid") ;
   RETURN NEW;
END;
$$;


ALTER FUNCTION public."receteOlustur"() OWNER TO postgres;

--
-- Name: receteekle(smallint, smallint, text, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.receteekle(receteid smallint, hastaid smallint, ilacadi text, doktorid smallint) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
   INSERT INTO public.recete ("receteid","hastaid","ilacadi","doktorid") VALUES (receteid,hastaid,ilacadi,doktorid);
END;
$$;


ALTER FUNCTION public.receteekle(receteid smallint, hastaid smallint, ilacadi text, doktorid smallint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Bolumler; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler."Bolumler" (
    bolumid integer NOT NULL,
    bolumadi character varying(20) NOT NULL
);


ALTER TABLE hastaneler."Bolumler" OWNER TO postgres;

--
-- Name: Bolumler_bolumid_seq; Type: SEQUENCE; Schema: hastaneler; Owner: postgres
--

CREATE SEQUENCE hastaneler."Bolumler_bolumid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hastaneler."Bolumler_bolumid_seq" OWNER TO postgres;

--
-- Name: Bolumler_bolumid_seq; Type: SEQUENCE OWNED BY; Schema: hastaneler; Owner: postgres
--

ALTER SEQUENCE hastaneler."Bolumler_bolumid_seq" OWNED BY hastaneler."Bolumler".bolumid;


--
-- Name: Hastaneler; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler."Hastaneler" (
    hastanekodu integer NOT NULL,
    ilcekodu smallint NOT NULL,
    ilkodu smallint NOT NULL,
    ilceadi character varying(30) NOT NULL,
    adi character varying(30) NOT NULL
);


ALTER TABLE hastaneler."Hastaneler" OWNER TO postgres;

--
-- Name: Hastaneler_hastanekodu_seq; Type: SEQUENCE; Schema: hastaneler; Owner: postgres
--

CREATE SEQUENCE hastaneler."Hastaneler_hastanekodu_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hastaneler."Hastaneler_hastanekodu_seq" OWNER TO postgres;

--
-- Name: Hastaneler_hastanekodu_seq; Type: SEQUENCE OWNED BY; Schema: hastaneler; Owner: postgres
--

ALTER SEQUENCE hastaneler."Hastaneler_hastanekodu_seq" OWNED BY hastaneler."Hastaneler".hastanekodu;


--
-- Name: Ilceler; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler."Ilceler" (
    ilcekodu integer NOT NULL,
    ilkodu smallint NOT NULL,
    ilceadi character varying(30) NOT NULL
);


ALTER TABLE hastaneler."Ilceler" OWNER TO postgres;

--
-- Name: Ilceler_ilcekodu_seq; Type: SEQUENCE; Schema: hastaneler; Owner: postgres
--

CREATE SEQUENCE hastaneler."Ilceler_ilcekodu_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hastaneler."Ilceler_ilcekodu_seq" OWNER TO postgres;

--
-- Name: Ilceler_ilcekodu_seq; Type: SEQUENCE OWNED BY; Schema: hastaneler; Owner: postgres
--

ALTER SEQUENCE hastaneler."Ilceler_ilcekodu_seq" OWNED BY hastaneler."Ilceler".ilcekodu;


--
-- Name: Iller; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler."Iller" (
    plaka integer NOT NULL,
    adi character varying(20) NOT NULL
);


ALTER TABLE hastaneler."Iller" OWNER TO postgres;

--
-- Name: Iller_plaka_seq; Type: SEQUENCE; Schema: hastaneler; Owner: postgres
--

CREATE SEQUENCE hastaneler."Iller_plaka_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hastaneler."Iller_plaka_seq" OWNER TO postgres;

--
-- Name: Iller_plaka_seq; Type: SEQUENCE OWNED BY; Schema: hastaneler; Owner: postgres
--

ALTER SEQUENCE hastaneler."Iller_plaka_seq" OWNED BY hastaneler."Iller".plaka;


--
-- Name: acilanbolumler; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler.acilanbolumler (
    a_bolumid integer NOT NULL,
    bolumadi character varying(30) NOT NULL,
    hastanekodu smallint NOT NULL
);


ALTER TABLE hastaneler.acilanbolumler OWNER TO postgres;

--
-- Name: acilanbolumler_a_bolumid_seq; Type: SEQUENCE; Schema: hastaneler; Owner: postgres
--

CREATE SEQUENCE hastaneler.acilanbolumler_a_bolumid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hastaneler.acilanbolumler_a_bolumid_seq OWNER TO postgres;

--
-- Name: acilanbolumler_a_bolumid_seq; Type: SEQUENCE OWNED BY; Schema: hastaneler; Owner: postgres
--

ALTER SEQUENCE hastaneler.acilanbolumler_a_bolumid_seq OWNED BY hastaneler.acilanbolumler.a_bolumid;


--
-- Name: asistan; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler.asistan (
    doktorid smallint NOT NULL,
    asistanid smallint NOT NULL,
    asistanadi character varying(30) NOT NULL,
    sifre character varying NOT NULL
);


ALTER TABLE hastaneler.asistan OWNER TO postgres;

--
-- Name: doctorlar; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler.doctorlar (
    docid integer NOT NULL,
    docbrans character varying(30) NOT NULL,
    docad character varying(30) NOT NULL,
    unvan character varying(30) NOT NULL,
    docsoyad character varying(30) NOT NULL,
    hastanesi smallint NOT NULL
);


ALTER TABLE hastaneler.doctorlar OWNER TO postgres;

--
-- Name: doctorlar_docid_seq; Type: SEQUENCE; Schema: hastaneler; Owner: postgres
--

CREATE SEQUENCE hastaneler.doctorlar_docid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hastaneler.doctorlar_docid_seq OWNER TO postgres;

--
-- Name: doctorlar_docid_seq; Type: SEQUENCE OWNED BY; Schema: hastaneler; Owner: postgres
--

ALTER SEQUENCE hastaneler.doctorlar_docid_seq OWNED BY hastaneler.doctorlar.docid;


--
-- Name: ilaclar; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler.ilaclar (
    ilacid integer NOT NULL,
    ilacadi character varying(30) NOT NULL
);


ALTER TABLE hastaneler.ilaclar OWNER TO postgres;

--
-- Name: ilaclar_ilacid_seq; Type: SEQUENCE; Schema: hastaneler; Owner: postgres
--

CREATE SEQUENCE hastaneler.ilaclar_ilacid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hastaneler.ilaclar_ilacid_seq OWNER TO postgres;

--
-- Name: ilaclar_ilacid_seq; Type: SEQUENCE OWNED BY; Schema: hastaneler; Owner: postgres
--

ALTER SEQUENCE hastaneler.ilaclar_ilacid_seq OWNED BY hastaneler.ilaclar.ilacid;


--
-- Name: unvanlar; Type: TABLE; Schema: hastaneler; Owner: postgres
--

CREATE TABLE hastaneler.unvanlar (
    unvanadi character varying(30) NOT NULL
);


ALTER TABLE hastaneler.unvanlar OWNER TO postgres;

--
-- Name: acilanrandevular; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acilanrandevular (
    rndid smallint NOT NULL,
    rndtarih text NOT NULL,
    rndsaat text NOT NULL,
    rndhastane smallint NOT NULL,
    rndbolum character varying(30) NOT NULL,
    rnddoc smallint NOT NULL
);


ALTER TABLE public.acilanrandevular OWNER TO postgres;

--
-- Name: hasta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hasta (
    hastaid integer NOT NULL,
    hastaadi character varying(30) NOT NULL,
    hastasoyadi character varying(30) NOT NULL,
    sifre text NOT NULL
);


ALTER TABLE public.hasta OWNER TO postgres;

--
-- Name: hasta_hastaid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hasta_hastaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hasta_hastaid_seq OWNER TO postgres;

--
-- Name: hasta_hastaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hasta_hastaid_seq OWNED BY public.hasta.hastaid;


--
-- Name: hastagecmisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hastagecmisi (
    hastaid smallint NOT NULL,
    hastane smallint NOT NULL,
    randevuid smallint NOT NULL
);


ALTER TABLE public.hastagecmisi OWNER TO postgres;

--
-- Name: ilaclarim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ilaclarim (
    ilacadi character varying NOT NULL,
    recetid smallint NOT NULL,
    hastaid smallint NOT NULL
);


ALTER TABLE public.ilaclarim OWNER TO postgres;

--
-- Name: randevular; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.randevular (
    rndid integer NOT NULL,
    rndtarih text NOT NULL,
    rndsaat text NOT NULL,
    rndhastane smallint NOT NULL,
    rndbolum character varying(30) NOT NULL,
    rnddoc smallint NOT NULL
);


ALTER TABLE public.randevular OWNER TO postgres;

--
-- Name: randevular_rndid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.randevular_rndid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.randevular_rndid_seq OWNER TO postgres;

--
-- Name: randevular_rndid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.randevular_rndid_seq OWNED BY public.randevular.rndid;


--
-- Name: randevularim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.randevularim (
    randid smallint NOT NULL,
    hastaid smallint NOT NULL
);


ALTER TABLE public.randevularim OWNER TO postgres;

--
-- Name: recete; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recete (
    receteid smallint NOT NULL,
    hastaid smallint NOT NULL,
    ilacadi character varying(20) NOT NULL,
    doktorid smallint NOT NULL
);


ALTER TABLE public.recete OWNER TO postgres;

--
-- Name: Bolumler bolumid; Type: DEFAULT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Bolumler" ALTER COLUMN bolumid SET DEFAULT nextval('hastaneler."Bolumler_bolumid_seq"'::regclass);


--
-- Name: Hastaneler hastanekodu; Type: DEFAULT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Hastaneler" ALTER COLUMN hastanekodu SET DEFAULT nextval('hastaneler."Hastaneler_hastanekodu_seq"'::regclass);


--
-- Name: Ilceler ilcekodu; Type: DEFAULT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Ilceler" ALTER COLUMN ilcekodu SET DEFAULT nextval('hastaneler."Ilceler_ilcekodu_seq"'::regclass);


--
-- Name: Iller plaka; Type: DEFAULT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Iller" ALTER COLUMN plaka SET DEFAULT nextval('hastaneler."Iller_plaka_seq"'::regclass);


--
-- Name: acilanbolumler a_bolumid; Type: DEFAULT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.acilanbolumler ALTER COLUMN a_bolumid SET DEFAULT nextval('hastaneler.acilanbolumler_a_bolumid_seq'::regclass);


--
-- Name: doctorlar docid; Type: DEFAULT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.doctorlar ALTER COLUMN docid SET DEFAULT nextval('hastaneler.doctorlar_docid_seq'::regclass);


--
-- Name: ilaclar ilacid; Type: DEFAULT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.ilaclar ALTER COLUMN ilacid SET DEFAULT nextval('hastaneler.ilaclar_ilacid_seq'::regclass);


--
-- Name: hasta hastaid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta ALTER COLUMN hastaid SET DEFAULT nextval('public.hasta_hastaid_seq'::regclass);


--
-- Name: randevular rndid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular ALTER COLUMN rndid SET DEFAULT nextval('public.randevular_rndid_seq'::regclass);


--
-- Data for Name: Bolumler; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler."Bolumler" (bolumid, bolumadi) VALUES
	(8, 'akciğer hastalıklar'),
	(2, 'anestezi'),
	(7, 'iç hastalıklar'),
	(6, 'genel cerrahi'),
	(4, 'cocuk hastalıkları'),
	(5, 'dahiliye'),
	(9, 'cildiye');


--
-- Data for Name: Hastaneler; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler."Hastaneler" (hastanekodu, ilcekodu, ilkodu, ilceadi, adi) VALUES
	(2, 7, 5, 'Keçiören', 'Keçiören Devlet Hastanesi'),
	(3, 2, 2, 'Köprübaşı', 'Adana Şehir Hastanesi'),
	(5, 8, 7, 'Manavgat', 'Antalya Şehir Hastanesi'),
	(6, 10, 9, 'Sivrihisar', 'Sivrihisar Araştırma Hastanesi');


--
-- Data for Name: Ilceler; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler."Ilceler" (ilcekodu, ilkodu, ilceadi) VALUES
	(1, 1, 'Çukurova'),
	(2, 2, 'Köprübaşı'),
	(3, 3, 'Karahisar'),
	(4, 4, 'Çukurova'),
	(5, 5, 'Çelenkler'),
	(6, 6, 'Kırkağaç'),
	(7, 5, 'Keçiören'),
	(9, 8, 'Peçenek'),
	(10, 9, 'Sivrihisar'),
	(8, 7, 'Manavgat');


--
-- Data for Name: Iller; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler."Iller" (plaka, adi) VALUES
	(1, 'Adana'),
	(2, 'Adıyaman'),
	(3, 'Afyon'),
	(4, 'Ağrı'),
	(5, 'Amasya'),
	(6, 'Ankara'),
	(7, 'Antalya'),
	(8, 'Artvin'),
	(9, 'Aydın');


--
-- Data for Name: acilanbolumler; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler.acilanbolumler (a_bolumid, bolumadi, hastanekodu) VALUES
	(7, 'akciğer hastalıklar', 3),
	(8, 'anestezi', 2),
	(11, 'dahiliye', 3),
	(12, 'anestezi', 3);


--
-- Data for Name: asistan; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler.asistan (doktorid, asistanid, asistanadi, sifre) VALUES
	(1, 1, 'ahmet', '1234');


--
-- Data for Name: doctorlar; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler.doctorlar (docid, docbrans, docad, unvan, docsoyad, hastanesi) VALUES
	(5, 'anestezi', 'resul', 'PROFESÖR', 'çalışkan', 3),
	(4, 'cildiye', 'Merve', 'DOÇENT', 'Nur', 5);


--
-- Data for Name: ilaclar; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler.ilaclar (ilacid, ilacadi) VALUES
	(1, 'pastil'),
	(2, 'parol'),
	(3, 'gripin'),
	(8, 'nurofen'),
	(9, 'aferin'),
	(10, 'theraflu');


--
-- Data for Name: unvanlar; Type: TABLE DATA; Schema: hastaneler; Owner: postgres
--

INSERT INTO hastaneler.unvanlar (unvanadi) VALUES
	('PRATİSYEN'),
	('YARDIMCI DOÇENT'),
	('DOÇENT'),
	('UZMAN'),
	('PROFESÖR');


--
-- Data for Name: acilanrandevular; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.acilanrandevular (rndid, rndtarih, rndsaat, rndhastane, rndbolum, rnddoc) VALUES
	(6, '21/12/2021', '12:30', 5, 'cildiye', 4),
	(2, '22/12/2021', '12:00', 3, 'anestezi', 5),
	(4, '21/12/2021', '12:10', 3, 'anestezi', 5),
	(5, '21/12/2021', '12:20', 5, 'cildiye', 4),
	(12, '25/12/2021', '13:30', 5, 'anestezi', 5);


--
-- Data for Name: hasta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hasta (hastaid, hastaadi, hastasoyadi, sifre) VALUES
	(1, 'Resul', 'Çalışkan', '1234'),
	(2, 'Ahmet', 'Taş', '1234'),
	(3, 'Mehmet', 'Veli', '1234'),
	(4, 'ali', 'veli', '1234'),
	(5, 'talha', 'gülören', '1234');


--
-- Data for Name: hastagecmisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hastagecmisi (hastaid, hastane, randevuid) VALUES
	(1, 3, 2),
	(5, 2, 5);


--
-- Data for Name: ilaclarim; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ilaclarim (ilacadi, recetid, hastaid) VALUES
	('aferin', 2, 1),
	('parol', 1, 2),
	('parol', 3, 1);


--
-- Data for Name: randevular; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.randevular (rndid, rndtarih, rndsaat, rndhastane, rndbolum, rnddoc) VALUES
	(2, '22/12/2021', '12:00', 3, 'anestezi', 5),
	(4, '21/12/2021', '12:10', 3, 'anestezi', 5),
	(5, '21/12/2021', '12:20', 5, 'cildiye', 4),
	(6, '21/12/2021', '12:30', 5, 'cildiye', 4),
	(12, '25/12/2021', '13:30', 5, 'anestezi', 5);


--
-- Data for Name: randevularim; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.randevularim (randid, hastaid) VALUES
	(2, 1),
	(5, 2);


--
-- Data for Name: recete; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recete (receteid, hastaid, ilacadi, doktorid) VALUES
	(2, 1, 'aferin', 5),
	(1, 2, 'parol', 5),
	(3, 1, 'parol', 5);


--
-- Name: Bolumler_bolumid_seq; Type: SEQUENCE SET; Schema: hastaneler; Owner: postgres
--

SELECT pg_catalog.setval('hastaneler."Bolumler_bolumid_seq"', 9, true);


--
-- Name: Hastaneler_hastanekodu_seq; Type: SEQUENCE SET; Schema: hastaneler; Owner: postgres
--

SELECT pg_catalog.setval('hastaneler."Hastaneler_hastanekodu_seq"', 9, true);


--
-- Name: Ilceler_ilcekodu_seq; Type: SEQUENCE SET; Schema: hastaneler; Owner: postgres
--

SELECT pg_catalog.setval('hastaneler."Ilceler_ilcekodu_seq"', 10, true);


--
-- Name: Iller_plaka_seq; Type: SEQUENCE SET; Schema: hastaneler; Owner: postgres
--

SELECT pg_catalog.setval('hastaneler."Iller_plaka_seq"', 9, true);


--
-- Name: acilanbolumler_a_bolumid_seq; Type: SEQUENCE SET; Schema: hastaneler; Owner: postgres
--

SELECT pg_catalog.setval('hastaneler.acilanbolumler_a_bolumid_seq', 12, true);


--
-- Name: doctorlar_docid_seq; Type: SEQUENCE SET; Schema: hastaneler; Owner: postgres
--

SELECT pg_catalog.setval('hastaneler.doctorlar_docid_seq', 5, true);


--
-- Name: ilaclar_ilacid_seq; Type: SEQUENCE SET; Schema: hastaneler; Owner: postgres
--

SELECT pg_catalog.setval('hastaneler.ilaclar_ilacid_seq', 10, true);


--
-- Name: hasta_hastaid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hasta_hastaid_seq', 6, true);


--
-- Name: randevular_rndid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.randevular_rndid_seq', 12, true);


--
-- Name: Ilceler Ilceler_ilcekodu_key; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Ilceler"
    ADD CONSTRAINT "Ilceler_ilcekodu_key" UNIQUE (ilcekodu);


--
-- Name: acilanbolumler acilanbolumlerPK; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.acilanbolumler
    ADD CONSTRAINT "acilanbolumlerPK" PRIMARY KEY (bolumadi, hastanekodu);


--
-- Name: Bolumler bolumPK; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Bolumler"
    ADD CONSTRAINT "bolumPK" PRIMARY KEY (bolumid, bolumadi);


--
-- Name: Hastaneler hastanePK; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Hastaneler"
    ADD CONSTRAINT "hastanePK" PRIMARY KEY (hastanekodu);


--
-- Name: Ilceler ilcePK; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Ilceler"
    ADD CONSTRAINT "ilcePK" PRIMARY KEY (ilcekodu, ilkodu, ilceadi);


--
-- Name: Iller ilkodu; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Iller"
    ADD CONSTRAINT ilkodu PRIMARY KEY (plaka);


--
-- Name: Bolumler unique_Bolumler_bolumadi; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Bolumler"
    ADD CONSTRAINT "unique_Bolumler_bolumadi" UNIQUE (bolumadi);


--
-- Name: Hastaneler unique_Hastaneler_adi; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Hastaneler"
    ADD CONSTRAINT "unique_Hastaneler_adi" UNIQUE (adi);


--
-- Name: asistan unique_asistan_asistanid; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.asistan
    ADD CONSTRAINT unique_asistan_asistanid UNIQUE (asistanid);


--
-- Name: doctorlar unique_doctorlar_docid; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.doctorlar
    ADD CONSTRAINT unique_doctorlar_docid UNIQUE (docid);


--
-- Name: ilaclar unique_ilaclar_ilacadi; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.ilaclar
    ADD CONSTRAINT unique_ilaclar_ilacadi UNIQUE (ilacadi);


--
-- Name: ilaclar unique_ilaclar_ilacid; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.ilaclar
    ADD CONSTRAINT unique_ilaclar_ilacid UNIQUE (ilacid);


--
-- Name: unvanlar unique_unvanlar_unvanadi; Type: CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.unvanlar
    ADD CONSTRAINT unique_unvanlar_unvanadi PRIMARY KEY (unvanadi);


--
-- Name: hasta unique_hasta_hastaid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT unique_hasta_hastaid PRIMARY KEY (hastaid);


--
-- Name: ilaclarim unique_ilaclarim_ilacid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilaclarim
    ADD CONSTRAINT unique_ilaclarim_ilacid UNIQUE (recetid);


--
-- Name: randevular unique_randevular_rndid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT unique_randevular_rndid UNIQUE (rndid);


--
-- Name: randevularim unique_randevularim_randid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevularim
    ADD CONSTRAINT unique_randevularim_randid UNIQUE (randid);


--
-- Name: recete unique_recetegecmisi_receteid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recete
    ADD CONSTRAINT unique_recetegecmisi_receteid UNIQUE (receteid);


--
-- Name: index_a_bolumid; Type: INDEX; Schema: hastaneler; Owner: postgres
--

CREATE INDEX index_a_bolumid ON hastaneler.acilanbolumler USING btree (a_bolumid);


--
-- Name: hasta kayitKontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "kayitKontrol" BEFORE INSERT OR UPDATE ON public.hasta FOR EACH ROW EXECUTE FUNCTION public."kucukHarf"();


--
-- Name: hasta kayitKontrol2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "kayitKontrol2" BEFORE INSERT OR UPDATE ON public.hasta FOR EACH ROW EXECUTE FUNCTION public."boslukSil"();


--
-- Name: randevular randevuAsistan; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "randevuAsistan" AFTER INSERT ON public.randevular FOR EACH ROW EXECUTE FUNCTION public."randevuOlustur"();


--
-- Name: randevularim randevuKontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "randevuKontrol" AFTER INSERT ON public.randevularim FOR EACH ROW EXECUTE FUNCTION public."randevuAl"();


--
-- Name: recete receteAsistan; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "receteAsistan" AFTER INSERT ON public.recete FOR EACH ROW EXECUTE FUNCTION public."receteOlustur"();


--
-- Name: Hastaneler Hastaneler_ilcekodu_ilkodu_ilceadi_fkey; Type: FK CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Hastaneler"
    ADD CONSTRAINT "Hastaneler_ilcekodu_ilkodu_ilceadi_fkey" FOREIGN KEY (ilcekodu, ilkodu, ilceadi) REFERENCES hastaneler."Ilceler"(ilcekodu, ilkodu, ilceadi);


--
-- Name: acilanbolumler acilanbolumler_bolumadi_fkey; Type: FK CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.acilanbolumler
    ADD CONSTRAINT acilanbolumler_bolumadi_fkey FOREIGN KEY (bolumadi) REFERENCES hastaneler."Bolumler"(bolumadi);


--
-- Name: acilanbolumler acilanbolumler_hastanekodu_fkey; Type: FK CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.acilanbolumler
    ADD CONSTRAINT acilanbolumler_hastanekodu_fkey FOREIGN KEY (hastanekodu) REFERENCES hastaneler."Hastaneler"(hastanekodu);


--
-- Name: doctorlar doctorlar_docbrans_fkey; Type: FK CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.doctorlar
    ADD CONSTRAINT doctorlar_docbrans_fkey FOREIGN KEY (docbrans) REFERENCES hastaneler."Bolumler"(bolumadi);


--
-- Name: doctorlar doctorlar_hastanesi_fkey; Type: FK CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.doctorlar
    ADD CONSTRAINT doctorlar_hastanesi_fkey FOREIGN KEY (hastanesi) REFERENCES hastaneler."Hastaneler"(hastanekodu);


--
-- Name: doctorlar doctorlar_unvan_fkey; Type: FK CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler.doctorlar
    ADD CONSTRAINT doctorlar_unvan_fkey FOREIGN KEY (unvan) REFERENCES hastaneler.unvanlar(unvanadi);


--
-- Name: Ilceler ilFK; Type: FK CONSTRAINT; Schema: hastaneler; Owner: postgres
--

ALTER TABLE ONLY hastaneler."Ilceler"
    ADD CONSTRAINT "ilFK" FOREIGN KEY (ilkodu) REFERENCES hastaneler."Iller"(plaka);


--
-- Name: acilanrandevular acilanrandevular_rndbolum_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acilanrandevular
    ADD CONSTRAINT acilanrandevular_rndbolum_fkey FOREIGN KEY (rndbolum) REFERENCES hastaneler."Bolumler"(bolumadi);


--
-- Name: acilanrandevular acilanrandevular_rnddoc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acilanrandevular
    ADD CONSTRAINT acilanrandevular_rnddoc_fkey FOREIGN KEY (rnddoc) REFERENCES hastaneler.doctorlar(docid);


--
-- Name: acilanrandevular acilanrandevular_rndhastane_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acilanrandevular
    ADD CONSTRAINT acilanrandevular_rndhastane_fkey FOREIGN KEY (rndhastane) REFERENCES hastaneler."Hastaneler"(hastanekodu);


--
-- Name: acilanrandevular acilanrandevular_rndid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acilanrandevular
    ADD CONSTRAINT acilanrandevular_rndid_fkey FOREIGN KEY (rndid) REFERENCES public.randevular(rndid);


--
-- Name: hastagecmisi hastagecmisi_hastaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hastagecmisi
    ADD CONSTRAINT hastagecmisi_hastaid_fkey FOREIGN KEY (hastaid) REFERENCES public.hasta(hastaid);


--
-- Name: ilaclarim ilaclarim_hastaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilaclarim
    ADD CONSTRAINT ilaclarim_hastaid_fkey FOREIGN KEY (hastaid) REFERENCES public.hasta(hastaid);


--
-- Name: ilaclarim ilaclarim_ilacadi_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilaclarim
    ADD CONSTRAINT ilaclarim_ilacadi_fkey FOREIGN KEY (ilacadi) REFERENCES hastaneler.ilaclar(ilacadi);


--
-- Name: randevularim lnk_hasta_randevularim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevularim
    ADD CONSTRAINT lnk_hasta_randevularim FOREIGN KEY (hastaid) REFERENCES public.hasta(hastaid) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: randevular randevular_rndbolum_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT randevular_rndbolum_fkey FOREIGN KEY (rndbolum) REFERENCES hastaneler."Bolumler"(bolumadi);


--
-- Name: randevular randevular_rnddoc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT randevular_rnddoc_fkey FOREIGN KEY (rnddoc) REFERENCES hastaneler.doctorlar(docid);


--
-- Name: randevular randevular_rndhastane_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT randevular_rndhastane_fkey FOREIGN KEY (rndhastane) REFERENCES hastaneler."Hastaneler"(hastanekodu);


--
-- Name: randevularim randevularimFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevularim
    ADD CONSTRAINT "randevularimFK" FOREIGN KEY (hastaid) REFERENCES public.hasta(hastaid) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: randevularim randevularim_randid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevularim
    ADD CONSTRAINT randevularim_randid_fkey FOREIGN KEY (randid) REFERENCES public.randevular(rndid);


--
-- Name: recete recete_doktorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recete
    ADD CONSTRAINT recete_doktorid_fkey FOREIGN KEY (doktorid) REFERENCES hastaneler.doctorlar(docid);


--
-- Name: recete recete_hastaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recete
    ADD CONSTRAINT recete_hastaid_fkey FOREIGN KEY (hastaid) REFERENCES public.hasta(hastaid);


--
-- Name: recete recete_ilacadi_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recete
    ADD CONSTRAINT recete_ilacadi_fkey FOREIGN KEY (ilacadi) REFERENCES hastaneler.ilaclar(ilacadi);


--
-- PostgreSQL database dump complete
--

