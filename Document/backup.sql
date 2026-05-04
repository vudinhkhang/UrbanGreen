--
-- PostgreSQL database dump
--

\restrict limN9ncJ0ZbjzZF9UQcds9LKqEvz5hfYFDnsjzuUTNUU0mZC9WXYgojErU0XGA4

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-04 04:04:45

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 17370)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17369)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_id_seq OWNER TO postgres;

--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 219
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- TOC entry 222 (class 1259 OID 17381)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17380)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 221
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- TOC entry 224 (class 1259 OID 17391)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id bigint NOT NULL,
    content_type_id bigint NOT NULL,
    codename text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17390)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_permission_id_seq OWNER TO postgres;

--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- TOC entry 226 (class 1259 OID 17404)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id bigint NOT NULL,
    password text NOT NULL,
    last_login timestamp without time zone,
    is_superuser boolean NOT NULL,
    username text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp without time zone NOT NULL,
    first_name text NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17423)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17422)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 227
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- TOC entry 225 (class 1259 OID 17403)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_id_seq OWNER TO postgres;

--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 225
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- TOC entry 230 (class 1259 OID 17433)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17432)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- TOC entry 232 (class 1259 OID 17443)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id bigint NOT NULL,
    object_id text,
    object_repr text NOT NULL,
    action_flag bigint NOT NULL,
    change_message text NOT NULL,
    content_type_id bigint,
    user_id bigint NOT NULL,
    action_time timestamp without time zone NOT NULL
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17442)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_admin_log_id_seq OWNER TO postgres;

--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 231
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- TOC entry 234 (class 1259 OID 17458)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id bigint NOT NULL,
    app_label text NOT NULL,
    model text NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17457)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_content_type_id_seq OWNER TO postgres;

--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 233
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- TOC entry 236 (class 1259 OID 17470)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app text NOT NULL,
    name text NOT NULL,
    applied timestamp without time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17469)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 235
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- TOC entry 237 (class 1259 OID 17482)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key text NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp without time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17887)
-- Name: public_map_activitylog; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_activitylog (
    id bigint NOT NULL,
    action_type character varying(32) NOT NULL,
    entity_type character varying(32) NOT NULL,
    entity_code character varying(120) NOT NULL,
    detail text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.public_map_activitylog OWNER TO urbangreen_user;

--
-- TOC entry 248 (class 1259 OID 17886)
-- Name: public_map_activitylog_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_activitylog ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_activitylog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 257 (class 1259 OID 17967)
-- Name: public_map_district; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_district (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    description text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.public_map_district OWNER TO urbangreen_user;

--
-- TOC entry 256 (class 1259 OID 17966)
-- Name: public_map_district_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_district ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_district_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 245 (class 1259 OID 17838)
-- Name: public_map_maintenancelog; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_maintenancelog (
    id bigint NOT NULL,
    date date NOT NULL,
    action character varying(200) NOT NULL,
    performer character varying(100) NOT NULL,
    note text NOT NULL,
    tree_id bigint NOT NULL,
    fertilizer_name character varying(150),
    pesticide_name character varying(150),
    water_amount double precision,
    measurement_height double precision,
    measurement_trunk_radius double precision,
    measurement_canopy_diameter double precision
);


ALTER TABLE public.public_map_maintenancelog OWNER TO urbangreen_user;

--
-- TOC entry 244 (class 1259 OID 17837)
-- Name: public_map_maintenancelog_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_maintenancelog ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_maintenancelog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 247 (class 1259 OID 17874)
-- Name: public_map_managementzone; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_managementzone (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    color character varying(7) NOT NULL,
    polygon_json text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.public_map_managementzone OWNER TO urbangreen_user;

--
-- TOC entry 246 (class 1259 OID 17873)
-- Name: public_map_managementzone_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_managementzone ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_managementzone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 253 (class 1259 OID 17925)
-- Name: public_map_soilquality; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_soilquality (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    soil_type character varying(20) NOT NULL,
    description text NOT NULL,
    growth_impact character varying(20) NOT NULL
);


ALTER TABLE public.public_map_soilquality OWNER TO urbangreen_user;

--
-- TOC entry 252 (class 1259 OID 17924)
-- Name: public_map_soilquality_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_soilquality ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_soilquality_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 251 (class 1259 OID 17907)
-- Name: public_map_treeimage; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_treeimage (
    id bigint NOT NULL,
    image character varying(100) NOT NULL,
    caption character varying(200) NOT NULL,
    uploaded_at timestamp with time zone NOT NULL,
    tree_id bigint NOT NULL
);


ALTER TABLE public.public_map_treeimage OWNER TO urbangreen_user;

--
-- TOC entry 250 (class 1259 OID 17906)
-- Name: public_map_treeimage_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_treeimage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_treeimage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 17666)
-- Name: public_map_treemetadata; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_treemetadata (
    id bigint NOT NULL,
    trunk_radius double precision,
    canopy_diameter double precision,
    planting_year integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    tree_id bigint NOT NULL
);


ALTER TABLE public.public_map_treemetadata OWNER TO urbangreen_user;

--
-- TOC entry 238 (class 1259 OID 17665)
-- Name: public_map_treemetadata_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_treemetadata ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_treemetadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 241 (class 1259 OID 17804)
-- Name: public_map_treespecies; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_treespecies (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    characteristics text NOT NULL,
    inspection_frequency_days integer NOT NULL,
    is_pest_prone boolean NOT NULL,
    watering_frequency_days integer NOT NULL,
    is_drought_sensitive boolean NOT NULL,
    is_fall_prone boolean NOT NULL,
    is_fast_growing boolean NOT NULL,
    is_invasive_roots boolean NOT NULL,
    CONSTRAINT public_map_treespecies_inspection_frequency_days_check CHECK ((inspection_frequency_days >= 0)),
    CONSTRAINT public_map_treespecies_watering_frequency_days_check CHECK ((watering_frequency_days >= 0))
);


ALTER TABLE public.public_map_treespecies OWNER TO urbangreen_user;

--
-- TOC entry 240 (class 1259 OID 17803)
-- Name: public_map_treespecies_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_treespecies ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_treespecies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 17815)
-- Name: public_map_urbantree; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_urbantree (
    id bigint NOT NULL,
    code character varying(20) NOT NULL,
    height double precision NOT NULL,
    status character varying(50) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    address character varying(200) NOT NULL,
    species_id bigint NOT NULL,
    image character varying(100),
    trunk_radius double precision,
    canopy_diameter double precision,
    planting_year integer,
    district_id bigint
);


ALTER TABLE public.public_map_urbantree OWNER TO urbangreen_user;

--
-- TOC entry 242 (class 1259 OID 17814)
-- Name: public_map_urbantree_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_urbantree ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_urbantree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 255 (class 1259 OID 17942)
-- Name: public_map_urbantree_soil_qualities; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_urbantree_soil_qualities (
    id bigint NOT NULL,
    urbantree_id bigint NOT NULL,
    soilquality_id bigint NOT NULL
);


ALTER TABLE public.public_map_urbantree_soil_qualities OWNER TO urbangreen_user;

--
-- TOC entry 254 (class 1259 OID 17941)
-- Name: public_map_urbantree_soil_qualities_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_urbantree_soil_qualities ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_urbantree_soil_qualities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 259 (class 1259 OID 17989)
-- Name: public_map_usermanageddistrict; Type: TABLE; Schema: public; Owner: urbangreen_user
--

CREATE TABLE public.public_map_usermanageddistrict (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    district_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.public_map_usermanageddistrict OWNER TO urbangreen_user;

--
-- TOC entry 258 (class 1259 OID 17988)
-- Name: public_map_usermanageddistrict_id_seq; Type: SEQUENCE; Schema: public; Owner: urbangreen_user
--

ALTER TABLE public.public_map_usermanageddistrict ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.public_map_usermanageddistrict_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4957 (class 2604 OID 17373)
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- TOC entry 4958 (class 2604 OID 17384)
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 4959 (class 2604 OID 17394)
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- TOC entry 4960 (class 2604 OID 17407)
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- TOC entry 4961 (class 2604 OID 17426)
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- TOC entry 4962 (class 2604 OID 17436)
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 4963 (class 2604 OID 17446)
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- TOC entry 4964 (class 2604 OID 17461)
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- TOC entry 4965 (class 2604 OID 17473)
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- TOC entry 5206 (class 0 OID 17370)
-- Dependencies: 220
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 5208 (class 0 OID 17381)
-- Dependencies: 222
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5210 (class 0 OID 17391)
-- Dependencies: 224
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, content_type_id, codename, name) FROM stdin;
1	1	add_logentry	Can add log entry
2	1	change_logentry	Can change log entry
3	1	delete_logentry	Can delete log entry
4	1	view_logentry	Can view log entry
5	3	add_permission	Can add permission
6	3	change_permission	Can change permission
7	3	delete_permission	Can delete permission
8	3	view_permission	Can view permission
9	2	add_group	Can add group
10	2	change_group	Can change group
11	2	delete_group	Can delete group
12	2	view_group	Can view group
13	4	add_user	Can add user
14	4	change_user	Can change user
15	4	delete_user	Can delete user
16	4	view_user	Can view user
17	5	add_contenttype	Can add content type
18	5	change_contenttype	Can change content type
19	5	delete_contenttype	Can delete content type
20	5	view_contenttype	Can view content type
21	6	add_session	Can add session
22	6	change_session	Can change session
23	6	delete_session	Can delete session
24	6	view_session	Can view session
25	8	add_urbantree	Can add urban tree
26	8	change_urbantree	Can change urban tree
27	8	delete_urbantree	Can delete urban tree
28	8	view_urbantree	Can view urban tree
29	7	add_treespecies	Can add tree species
30	7	change_treespecies	Can change tree species
31	7	delete_treespecies	Can delete tree species
32	7	view_treespecies	Can view tree species
33	9	add_maintenancelog	Can add maintenance log
34	9	change_maintenancelog	Can change maintenance log
35	9	delete_maintenancelog	Can delete maintenance log
36	9	view_maintenancelog	Can view maintenance log
37	10	add_managementzone	Can add management zone
38	10	change_managementzone	Can change management zone
39	10	delete_managementzone	Can delete management zone
40	10	view_managementzone	Can view management zone
41	11	add_activitylog	Can add Nhật ký hoạt động
42	11	change_activitylog	Can change Nhật ký hoạt động
43	11	delete_activitylog	Can delete Nhật ký hoạt động
44	11	view_activitylog	Can view Nhật ký hoạt động
45	12	add_treeimage	Can add tree image
46	12	change_treeimage	Can change tree image
47	12	delete_treeimage	Can delete tree image
48	12	view_treeimage	Can view tree image
49	13	add_treemetadata	Can add Metadata Cây
50	13	change_treemetadata	Can change Metadata Cây
51	13	delete_treemetadata	Can delete Metadata Cây
52	13	view_treemetadata	Can view Metadata Cây
53	14	add_soilquality	Can add soil quality
54	14	change_soilquality	Can change soil quality
55	14	delete_soilquality	Can delete soil quality
56	14	view_soilquality	Can view soil quality
57	15	add_district	Can add Quận/Huyện
58	15	change_district	Can change Quận/Huyện
59	15	delete_district	Can delete Quận/Huyện
60	15	view_district	Can view Quận/Huyện
61	16	add_usermanageddistrict	Can add Quận/Huyện được quản lý
62	16	change_usermanageddistrict	Can change Quận/Huyện được quản lý
63	16	delete_usermanageddistrict	Can delete Quận/Huyện được quản lý
64	16	view_usermanageddistrict	Can view Quận/Huyện được quản lý
\.


--
-- TOC entry 5212 (class 0 OID 17404)
-- Dependencies: 226
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, last_name, email, is_staff, is_active, date_joined, first_name) FROM stdin;
5	pbkdf2_sha256$1200000$srhtFMeiGbvN6nY9pMkIS6$PlRJJrQuKYBnYbky2+bLBeVMz55N/OrfUSNRnfJ3pwk=	\N	f	user0002	vd	gmail@gmail.com	f	t	2026-04-08 09:00:43.127003	khang
2	pbkdf2_sha256$1200000$W7QeMPqQm9ujWLFVQsMKmZ$HFmMdF3spIrhVCAh1BKh9MYL2ojZFRO1nx+PtlGTduI=	2026-04-14 23:53:30.613527	t	admin	Vd	1250080081@sv.hcmunre.edu.vn	t	t	2026-02-05 21:55:50.190556	Khang
7		\N	f	admin_test		admin@example.com	t	t	2026-04-15 05:56:52.136356	
3	pbkdf2_sha256$1200000$cdOxAq3X3KEVcgOthV3YD1$vOc0sYIJlZQL5pc0rd1SOLIKkhT0GsVl4tD0W03syr4=	2026-05-03 18:02:40.992269	f	demo_user	Nguyễn Quốc	1250080075@sv.hcmunre.edu.vn	f	t	2026-03-26 16:11:17.226865	Huy12
8	pbkdf2_sha256$1200000$wKZTbG5HwRWj4snf09WJ5R$o6+ZXvY6bB0DM2bVwdwUuRtN2raeWWisCQu9UY4EJS8=	2026-05-03 18:11:33.920286	f	khang	khang		f	t	2026-04-15 06:04:29.000653	khang
4	pbkdf2_sha256$1200000$i7KSeIN9laQk3S5otkJeQM$t0eRcJ2+sdTGTooN0Mqw47IbamP/+WNTs+U+XiXrhUA=	\N	f	user1	Trần Nguyễn Trung	1250080090@sv.hcmunre.edu.vn	f	t	2026-04-01 05:35:57.576576	Kiên
\.


--
-- TOC entry 5214 (class 0 OID 17423)
-- Dependencies: 228
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 5216 (class 0 OID 17433)
-- Dependencies: 230
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5218 (class 0 OID 17443)
-- Dependencies: 232
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, object_id, object_repr, action_flag, change_message, content_type_id, user_id, action_time) FROM stdin;
1	1	k	3		4	2	2026-02-06 04:56:58.929563
2	1	Phượng Vĩ	1	[{"added": {}}]	7	2	2026-02-06 05:02:20.919156
3	2	Xà Cừ	1	[{"added": {}}]	7	2	2026-02-06 05:02:32.875188
4	1	PV_001 - Phượng Vĩ	1	[{"added": {}}]	8	2	2026-02-06 05:05:05.960788
5	1	PV_001 - Phượng Vĩ	2	[{"changed": {"fields": ["H\\u00ecnh \\u1ea3nh"]}}]	8	2	2026-02-06 05:36:16.294071
6	2	XC_001 - Xà Cừ	1	[{"added": {}}]	8	2	2026-02-06 05:59:32.483018
7	2	XC_001 - Xà Cừ	2	[]	8	2	2026-02-06 06:21:56.552455
8	1	PV_001 - Phượng Vĩ	2	[]	8	2	2026-02-06 06:22:00.051588
9	3	BL_001 - Cây Bằng Lăng	1	[{"added": {}}]	8	2	2026-02-06 06:45:49.757765
\.


--
-- TOC entry 5220 (class 0 OID 17458)
-- Dependencies: 234
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	public_map	treespecies
8	public_map	urbantree
9	public_map	maintenancelog
10	public_map	managementzone
11	public_map	activitylog
12	public_map	treeimage
13	public_map	treemetadata
14	public_map	soilquality
15	public_map	district
16	public_map	usermanageddistrict
\.


--
-- TOC entry 5222 (class 0 OID 17470)
-- Dependencies: 236
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-02-06 04:08:58.822974
2	auth	0001_initial	2026-02-06 04:08:58.858224
3	admin	0001_initial	2026-02-06 04:08:58.886391
4	admin	0002_logentry_remove_auto_add	2026-02-06 04:08:58.914528
5	admin	0003_logentry_add_action_flag_choices	2026-02-06 04:08:58.932801
6	contenttypes	0002_remove_content_type_name	2026-02-06 04:08:58.97998
7	auth	0002_alter_permission_name_max_length	2026-02-06 04:08:59.017163
8	auth	0003_alter_user_email_max_length	2026-02-06 04:08:59.057077
9	auth	0004_alter_user_username_opts	2026-02-06 04:08:59.08246
10	auth	0005_alter_user_last_login_null	2026-02-06 04:08:59.106057
11	auth	0006_require_contenttypes_0002	2026-02-06 04:08:59.113714
12	auth	0007_alter_validators_add_error_messages	2026-02-06 04:08:59.138365
13	auth	0008_alter_user_username_max_length	2026-02-06 04:08:59.161796
14	auth	0009_alter_user_last_name_max_length	2026-02-06 04:08:59.179153
15	auth	0010_alter_group_name_max_length	2026-02-06 04:08:59.209821
16	auth	0011_update_proxy_permissions	2026-02-06 04:08:59.231607
17	auth	0012_alter_user_first_name_max_length	2026-02-06 04:08:59.27399
18	sessions	0001_initial	2026-02-06 04:08:59.322711
60	public_map	0001_initial	2026-04-15 05:10:55.615384
61	public_map	0002_urbantree_image	2026-04-15 05:10:55.619285
62	public_map	0003_maintenancelog	2026-04-15 05:10:55.663398
63	public_map	0004_treespecies_inspection_frequency_days_and_more	2026-04-15 05:10:55.690507
64	public_map	0005_treespecies_is_drought_sensitive_and_more	2026-04-15 05:10:55.725648
65	public_map	0006_managementzone	2026-04-15 05:10:55.738747
66	public_map	0007_activitylog	2026-04-15 05:10:55.777147
67	public_map	0008_treeimage	2026-04-15 05:10:55.795918
68	public_map	0009_urbantree_add_measurements	2026-04-15 05:10:55.822968
69	public_map	0010_add_maintenance_fields	2026-04-15 05:10:55.850884
70	public_map	0011_soilquality_alter_maintenancelog_action_and_more	2026-04-15 05:40:18.239823
71	public_map	0012_district_urbantree_district_usermanageddistrict	2026-04-15 05:51:59.311637
\.


--
-- TOC entry 5223 (class 0 OID 17482)
-- Dependencies: 237
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
is0qztxerumej7lu2rv55p6mdy5wd2eg	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1voFa4:nA1yDXxiWrwn_FSXr1T53yH3ILxUwye6Y3jLxruDvnU	2026-02-20 06:44:40.56835
eqxrn5vr4m0tmcdmu49wbr1xki0j1wvk	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1vyQKR:KKj5ssQHEYItSS5QGUCw3cLosvb838a_6AHmKVvF_RM	2026-03-20 08:14:35.716551
kmj7ipn6bens9ok1t7n8bzekk8nv0gkz	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w60nr:tf0AqRQs1ymP6tmnw1GB1jlXM0T5Dz7lmSficShtKlM	2026-04-10 06:36:19.334548
xef1v9b0kxu9jfieoeoe1xmlet65nzja	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w60pO:N8aOPh4esCfPClTGkO2XeKIgbtu7-hk9vmT-KgE-Tsk	2026-04-10 06:37:54.736379
5h5ehqdtujvsj11ymqtirce7d1y94n2y	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w60pm:iEMTVqNZrf_9GqENNiUY_saSwvJF30Yst68yxEZF_pw	2026-04-10 06:38:18.093284
bcqyorz8hgcy5gv8br7b630qiw4ph4oa	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w60uz:gbCvCb7CaSO3GmYir3G5Rh3N30i5gWCgANxKz8FS32g	2026-04-10 06:43:41.458067
jzmrklg53zzdnmjfjt79g2fsr6qziy34	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w6154:DcG1aToxxKVhaeweComovZzjcQArCE2raD2MXlcMQs8	2026-04-10 06:54:06.162272
ktzclot8mx5zzi0pxvid6ek713idwjer	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w615e:bCVdvIH6-hPuxCbRJBTu18TR5ko_fzzl9_79-QVNhSY	2026-04-10 06:54:42.461037
ere573n69gytjta4l4bphi0xvxjssu3u	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61GW:i-E_Qov7d5BuZpBDWMYYO-UnPSEPySp6duLrU1JKpj4	2026-04-10 07:05:56.159152
4dxmcg50o4pekd9uohxi6v908e65d2to	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61LX:QuTYuFa2rFJrIvC774-8xVuOPJ8IhPHn7SmmfsI_Mkc	2026-04-10 07:11:07.893967
i9vxwld66m2hoxdoquolk96asgxxs6o1	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61Nq:lI0rdhl2Fxk4G8ON4kJ4KDDdFxawNVZpgYKHswNqK8Y	2026-04-10 07:13:30.122834
g9lvxlsw7r9p9gf2679pw63qggn0ugcg	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61Nz:2F5rfoZeg6BF6muAJTkwJpXW_YVGDTdmTcX66IwcrVk	2026-04-10 07:13:39.984746
go2z94fa0t606mdttpm89j2etf3al8xl	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61OY:Z0g4y9zBmyd__-6EDhMsivuVR7U4tiJl4Rlcmw6FbiE	2026-04-10 07:14:14.060266
mpj0vlfkjmp5ghfscs6rssf312mknkyp	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w61V0:mWZCvZXBFMpv-iXOLNqf8yoHcf7dtGgEcxC254nZ7qw	2026-04-10 07:20:54.878493
4s7xtek964oa0m96cnddi0s854lyqypa	.eJxVjMsOwiAQAP9lz4bw6gI9evcbGpYFqRpI-jgZ_9006UGvM5N5wxT3rU77mpdpZhjBwOWXUUzP3A7Bj9juXaTetmUmcSTitKu4dc6v69n-DWpcK4xgnWSPypDTRErZMCSDJvtQbLIlsA42Fx0wMyZkCtopab2hAT2jZAOfL8guNy0:1w61bG:IADgVVwpfmKkgXOUEuJtgUSx3DCXWFb_prQx1dyG4NY	2026-04-10 07:27:22.308717
bxy1xma09f2ev9c8lgtvkwgwggjaftfi	.eJxVjEEOwiAQAP-yZ0MKFKE9eu8bmmV3kaqBpLQn499Nkx70OjOZN8y4b3nem6zzwjCCgcsvi0hPKYfgB5Z7VVTLti5RHYk6bVNTZXndzvZvkLFlGMEH24vFhGS19cnoKyHpHjUPLNEk8iG4pIkRvfMWXeqEBwmpcx5DIPh8Af3IOMg:1w62gl:lw6-GsjxHJFd7f5632gmvFgJwTwG6lxagJIy4FbE1nc	2026-04-10 08:37:07.905021
cb3fj55uoim8ltzt013sc0f7gb197pez	.eJxVjDEOgzAMAP_iuYqIILHD2L1vQHbsFNoKJAJT1b9XSAztene6Nwy8b-OwV1uHSaEHgssvE85Pmw-hD57vi8vLvK2TuCNxp63utqi9rmf7Nxi5jtADBoyFcimBA3ZIyVpqBFWljegTZvREopwtNEmsi4GlQaGixVLnGT5f6WI4Yg:1wCvOn:rSzLiXfJgdyJ5rUhDh6wUgn_RSOw_67BAY2_CamefJ8	2026-04-29 08:15:01.49883
a15dgzu4nt8b9y5hq70q9yu7h85wuh0p	.eJxVjMsOgjAQAP9lz6bpa6Hl6N1vINvtIqhpEwon478bEg56nZnMG0bat3ncm6zjkmEAC5dfloifUg6RH1TuVXEt27okdSTqtE3dapbX9Wz_BjO1GQZIPsWsZRKLxhiTpfMTs84conVe28Axsuv7ziAawsmjT5E0h4DiHPbw-QLjUjdH:1wCnZS:tascu5e7YH2AerQ_kuzclMGshor2cxGlRNJoWrujMVA	2026-04-28 23:53:30.627756
\.


--
-- TOC entry 5235 (class 0 OID 17887)
-- Dependencies: 249
-- Data for Name: public_map_activitylog; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_activitylog (id, action_type, entity_type, entity_code, detail, created_at, user_id) FROM stdin;
1	ADD_SPECIES	SPECIES	Đa	Thêm loài cây Đa	2026-04-15 12:12:57.481532+07	2
2	ADD_TREE	TREE	test001	Thêm cây mới test001 (Đa)	2026-04-15 12:13:16.515801+07	2
3	ADD_MAINTENANCE	TREE	test001	Thêm chăm sóc TUOI_NUOC cho cây test001 bởi Khang Vd	2026-04-15 12:13:24.476542+07	2
4	ADD_TREE	TREE	test001	Thêm cây mới test001 (Phượng Vĩ)	2026-04-15 12:45:37.480422+07	2
5	ADD_TREE	TREE	test002	Thêm cây mới test002 (Phượng Vĩ)	2026-04-15 12:49:12.60398+07	2
6	ADD_DISTRICT_PERM	USER_DISTRICT	user0002-Quận Bình Thạnh	Gán quyền quận Quận Bình Thạnh cho user0002	2026-04-15 13:03:32.454505+07	2
7	ADD_DISTRICT_PERM	USER_DISTRICT	khang-Quận Bình Thạnh	Gán quyền quận Quận Bình Thạnh cho khang	2026-04-15 13:04:36.875394+07	2
8	ADD_TREE	TREE	test003	Thêm cây mới test003 (Phượng Vĩ)	2026-04-15 13:05:59.199131+07	2
9	UPLOAD_IMAGE	TREE	PV_001	Cập nhật 2 ảnh cho cây PV_001	2026-04-15 13:42:45.061629+07	2
10	ADD_MAINTENANCE	TREE	PV_008	Thêm chăm sóc BON_PHAN cho cây PV_008 bởi Khang Vd	2026-04-15 15:12:26.236299+07	2
11	ADD_MAINTENANCE	TREE	PV_008	Thêm chăm sóc KIEM_TRA cho cây PV_008 bởi Khang Vd	2026-04-15 15:13:01.698997+07	2
12	ADD_TREE	TREE	TEST004	Thêm cây mới TEST004 (Phượng Vĩ)	2026-04-15 15:14:33.573737+07	2
\.


--
-- TOC entry 5243 (class 0 OID 17967)
-- Dependencies: 257
-- Data for Name: public_map_district; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_district (id, name, code, description, created_at) FROM stdin;
1	Quận 1	Q1	Trung tâm thành phố	2026-04-15 12:52:18.101802+07
2	Quận 2	Q2	Phía Đông Bắc	2026-04-15 12:52:18.108057+07
3	Quận 3	Q3	Phía Tây Bắc	2026-04-15 12:52:18.112441+07
4	Quận 4	Q4	Phía Nam	2026-04-15 12:52:18.114239+07
5	Quận 5	Q5	Phía Tây Nam	2026-04-15 12:52:18.117336+07
6	Quận 6	Q6	Phía Tây	2026-04-15 12:52:18.118866+07
7	Quận 7	Q7	Phía Nam Đông	2026-04-15 12:52:18.12313+07
8	Quận 8	Q8	Phía Nam Tây	2026-04-15 12:52:18.12735+07
9	Quận 9	Q9	Phía Đông	2026-04-15 12:52:18.131894+07
10	Quận 10	Q10	Phía Bắc	2026-04-15 12:52:18.135185+07
11	Quận 11	Q11	Phía Tây Bắc	2026-04-15 12:52:18.138315+07
12	Quận 12	Q12	Phía Bắc	2026-04-15 12:52:18.142139+07
13	Quận Bình Tân	BT	Phía Tây	2026-04-15 12:52:18.146152+07
14	Quận Bình Thạnh	BTH	Phía Đông	2026-04-15 12:52:18.150094+07
15	Quận Gò Vấp	GV	Phía Bắc	2026-04-15 12:52:18.155892+07
16	Quận Phú Nhuận	PN	Phía Bắc	2026-04-15 12:52:18.158349+07
17	Quận Tân Bình	TB	Phía Bắc Tây	2026-04-15 12:52:18.161583+07
18	Quận Tân Phú	TP	Phía Tây Bắc	2026-04-15 12:52:18.166439+07
19	Huyện Bình Chánh	BC	Phía Tây	2026-04-15 12:52:18.16844+07
20	Huyện Cần Giờ	CG	Phía Nam	2026-04-15 12:52:18.170055+07
21	Huyện Củ Chi	CC	Phía Tây Bắc	2026-04-15 12:52:18.172031+07
22	Huyện Nhà Bè	NB	Phía Đông Nam	2026-04-15 12:52:18.177094+07
\.


--
-- TOC entry 5231 (class 0 OID 17838)
-- Dependencies: 245
-- Data for Name: public_map_maintenancelog; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_maintenancelog (id, date, action, performer, note, tree_id, fertilizer_name, pesticide_name, water_amount, measurement_height, measurement_trunk_radius, measurement_canopy_diameter) FROM stdin;
2	2026-04-15	BON_PHAN	Khang Vd	Phân bón: loại Phân NPK	16	Phân NPK	\N	\N	\N	\N	\N
3	2026-04-15	KIEM_TRA	Khang Vd	Chiều cao cây: 14.1m (không thay đổi) | Đường kính thân cây: 43.3cm (không thay đổi) | Diện tích vòm: 114.0m² (không thay đổi)	16	\N	\N	\N	14.1	43.3	114
\.


--
-- TOC entry 5233 (class 0 OID 17874)
-- Dependencies: 247
-- Data for Name: public_map_managementzone; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_managementzone (id, name, color, polygon_json, created_at) FROM stdin;
\.


--
-- TOC entry 5239 (class 0 OID 17925)
-- Dependencies: 253
-- Data for Name: public_map_soilquality; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_soilquality (id, name, soil_type, description, growth_impact) FROM stdin;
1	Đất tốt	fertile	Đất màu mỡ, giàu dinh dưỡng, thoáng khí tốt.	accelerated
2	Đất xây dựng	compacted	Đất nén chặt từ xây dựng, ít dinh dưỡng, khó thoáng khí.	slows_growth
3	Đất chua	acidic	Đất có độ pH thấp, chua. Phù hợp với một số loài nhất định.	normal
\.


--
-- TOC entry 5237 (class 0 OID 17907)
-- Dependencies: 251
-- Data for Name: public_map_treeimage; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_treeimage (id, image, caption, uploaded_at, tree_id) FROM stdin;
1	tree_images/images_lh6v7Xz.jpg		2026-04-15 13:42:45.045482+07	1
2	tree_images/1588905423_2712_ac3c6ea58f7a18dd75a75725f4e5963a_kqCk7Wj.jpg		2026-04-15 13:42:45.052083+07	1
3	tree_images/2020_ezAeN8B.png		2026-04-15 15:14:33.55482+07	78
4	tree_images/2025_n25VeEW.png		2026-04-15 15:14:33.565588+07	78
\.


--
-- TOC entry 5225 (class 0 OID 17666)
-- Dependencies: 239
-- Data for Name: public_map_treemetadata; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_treemetadata (id, trunk_radius, canopy_diameter, planting_year, created_at, updated_at, tree_id) FROM stdin;
\.


--
-- TOC entry 5227 (class 0 OID 17804)
-- Dependencies: 241
-- Data for Name: public_map_treespecies; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_treespecies (id, name, characteristics, inspection_frequency_days, is_pest_prone, watering_frequency_days, is_drought_sensitive, is_fall_prone, is_fast_growing, is_invasive_roots) FROM stdin;
1	Phượng Vĩ	Rễ nông, cành giòn, dễ gãy đổ khi gặp gió bão. Cần cắt tỉa thường xuyên.	90	f	7	f	t	t	f
2	Xà Cừ	Rễ phát triển mạnh, dễ gây hư hại vỉa hè và công trình ngầm.	90	t	7	t	f	f	t
3	Cây Bằng Lăng	Hoa màu tím đẹp, tán lá rậm hình oval. Rễ cọc đâm sâu, ít phá hoại công trình ngầm	90	f	7	t	f	t	f
\.


--
-- TOC entry 5229 (class 0 OID 17815)
-- Dependencies: 243
-- Data for Name: public_map_urbantree; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_urbantree (id, code, height, status, latitude, longitude, address, species_id, image, trunk_radius, canopy_diameter, planting_year, district_id) FROM stdin;
1	PV_001	8.5	TOT	10.85294	106.62953	Cổng chính Công viên Phần mềm Quang Trung, Q.12, TP.HCM	1	tree_images/images_Id04mPq.jpg	25	45	2015	\N
2	XC_001	15.2	SAU_BENH	10.77443	106.69228	Góc đường Trương Định - Nguyễn Thị Minh Khai, Q.1.	2		35	85	2012	\N
3	BL_001	4.5	TOT	10.85325	106.6297	Dọc lối đi bộ, tòa nhà QTSC 9, Q.12.	3		15	25	2018	\N
4	PV001	5	TOT	10.79550091253234	106.70108556747438	Sân bay	1		18	30	2016	\N
5	PV002	5	TOT	10.811681989723436	106.63737773895265	Sân bay	1		18	28	2017	\N
6	PV003	4	TOT	10.811892757424635	106.63803219795228	Sân bay	1		16	25	2018	\N
7	PV004	4	TOT	10.812156216842931	106.6387188434601	Sân bay	1		16	24	2018	\N
8	PV005	6	TOT	10.81240913766682	106.63944840431215	Sân bay	1		20	32	2017	\N
9	PV006	5.6	TOT	10.812577751430954	106.63995265960693	Sân bay	1		19	30	2017	\N
10	PV_002	5.6	TOT	10.855017	106.624705	Khu vực Công viên Phần mềm (Q.12)	1		17.8	46.9	2020	\N
11	PV_003	9.7	NGUY_HIEM	10.855106	106.627715	Khu vực Công viên Phần mềm (Q.12)	1		28.7	82.2	2015	\N
12	PV_004	15.5	SAU_BENH	10.849699	106.632056	Khu vực Công viên Phần mềm (Q.12)	1		47.4	129	2020	\N
13	PV_005	4.2	SAU_BENH	10.862329	106.629871	Khu vực Công viên Phần mềm (Q.12)	1		13.7	43.2	2018	\N
14	PV_006	7.3	NGUY_HIEM	10.84788	106.62696	Khu vực Công viên Phần mềm (Q.12)	1		22.5	58.5	2021	\N
15	PV_007	9.4	TOT	10.850023	106.628695	Khu vực Công viên Phần mềm (Q.12)	1		28.6	81.2	2024	\N
17	PV_009	7.6	NGUY_HIEM	10.855268	106.627398	Khu vực Công viên Phần mềm (Q.12)	2		24.1	56.8	2021	\N
18	PV_010	7.8	SAU_BENH	10.853547	106.632822	Khu vực Công viên Phần mềm (Q.12)	1		24.2	64.1	2021	\N
19	PV_011	13.5	TOT	10.858385	106.624649	Khu vực Công viên Phần mềm (Q.12)	3		40.7	108.7	2024	\N
20	PV_012	13.4	TOT	10.850446	106.62594	Khu vực Công viên Phần mềm (Q.12)	1		41.7	114	2013	\N
21	PV_013	15.6	TOT	10.848965	106.630578	Khu vực Công viên Phần mềm (Q.12)	1		46.7	131.1	2014	\N
22	PV_014	11.8	SAU_BENH	10.862308	106.635075	Khu vực Công viên Phần mềm (Q.12)	1		35.9	103.1	2016	\N
23	PV_015	4.9	NGUY_HIEM	10.858221	106.630019	Khu vực Công viên Phần mềm (Q.12)	1		14.5	37.9	2020	\N
24	PV_016	12	TOT	10.84809	106.623014	Khu vực Công viên Phần mềm (Q.12)	1		36.8	93.5	2016	\N
25	SB_001	12.8	TOT	10.81882	106.650898	Khu vực Sân bay (Q.1)	1		39.7	112.1	2012	\N
26	SB_002	12.3	TOT	10.808544	106.62812	Khu vực Sân bay (Q.1)	1		37.6	96.8	2022	\N
27	SB_003	7.5	TOT	10.801303	106.651409	Khu vực Sân bay (Q.1)	1		22.4	55.8	2019	\N
28	SB_004	10.1	TOT	10.827072	106.650146	Khu vực Sân bay (Q.1)	1		30	77.3	2012	\N
29	SB_005	9	TOT	10.806471	106.646433	Khu vực Sân bay (Q.1)	1		27.2	72.8	2023	\N
30	SB_006	5.8	NGUY_HIEM	10.800357	106.634102	Khu vực Sân bay (Q.1)	1		17.3	41.4	2022	\N
31	SB_007	7.4	TOT	10.804485	106.631215	Khu vực Sân bay (Q.1)	1		23.1	62.4	2020	\N
32	SB_008	5.9	SAU_BENH	10.818254	106.626673	Khu vực Sân bay (Q.1)	1		18.1	56.2	2024	\N
33	SB_009	10.1	TOT	10.806504	106.636308	Khu vực Sân bay (Q.1)	3		30.5	82	2016	\N
34	SB_010	4.3	TOT	10.819425	106.64086	Khu vực Sân bay (Q.1)	1		12.5	38.8	2019	\N
35	SB_011	5.7	TOT	10.804221	106.62909	Khu vực Sân bay (Q.1)	1		18.2	49.3	2020	\N
36	SB_012	9.2	SAU_BENH	10.826504	106.632186	Khu vực Sân bay (Q.1)	2		27.7	80.4	2018	\N
37	SB_013	10.9	TOT	10.812343	106.625201	Khu vực Sân bay (Q.1)	1		33	90.8	2016	\N
38	SB_014	6.1	TOT	10.824307	106.647821	Khu vực Sân bay (Q.1)	1		19.1	54.5	2020	\N
39	SB_015	9.4	NGUY_HIEM	10.819079	106.640147	Khu vực Sân bay (Q.1)	2		28.3	83	2024	\N
40	SB_016	4.8	TOT	10.797639	106.638984	Khu vực Sân bay (Q.1)	1		14.7	40.1	2019	\N
41	SB_017	6	NGUY_HIEM	10.827332	106.633619	Khu vực Sân bay (Q.1)	1		18.1	53	2017	\N
42	SB_018	14.1	TOT	10.816479	106.634731	Khu vực Sân bay (Q.1)	3		43.4	110.2	2022	\N
43	SB_019	6.1	TOT	10.817697	106.640409	Khu vực Sân bay (Q.1)	1		18.7	48.4	2022	\N
44	SB_020	12.4	TOT	10.807749	106.644975	Khu vực Sân bay (Q.1)	2		37.7	97.8	2023	\N
45	TSK_001	11.7	TOT	10.777655	106.701485	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	3		34.7	98.5	2018	\N
46	TSK_002	12.2	TOT	10.780341	106.682326	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	2		37.8	92.8	2021	\N
47	TSK_003	10.6	SAU_BENH	10.777066	106.694335	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	1		33	90.7	2023	\N
48	TSK_004	13.6	TOT	10.767297	106.697612	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	1		42.3	110.5	2023	\N
16	PV_008	14.1	SAU_BENH	10.862173	106.622604	Khu vực Công viên Phần mềm (Q.12)	3		43.3	114	2018	\N
49	TSK_005	8.9	TOT	10.785372	106.686455	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	1		26.5	68.2	2018	\N
50	TSK_006	13.9	SAU_BENH	10.773576	106.694503	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	1		41.3	114.1	2022	\N
51	TSK_007	10.6	TOT	10.767448	106.686133	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	2		31.6	92.1	2023	\N
52	TSK_008	4	TOT	10.768839	106.688737	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	3		13.3	37.7	2021	\N
53	TSK_009	8.8	NGUY_HIEM	10.7753	106.690337	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	2		26.7	74.6	2019	\N
54	TSK_010	6.7	TOT	10.776652	106.681344	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	2		20.7	60.7	2012	\N
55	TSK_011	9.7	TOT	10.762997	106.698199	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	1		30.1	79.2	2023	\N
56	TSK_012	7.6	NGUY_HIEM	10.781806	106.684421	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	3		23.9	59	2020	\N
57	TSK_013	9.2	NGUY_HIEM	10.766398	106.701651	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	3		27.9	69.6	2021	\N
58	TSK_014	7.5	TOT	10.771372	106.700451	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	2		24	56.9	2015	\N
59	TSK_015	13.3	TOT	10.779227	106.680617	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	1		40.6	104.2	2021	\N
60	TSK_016	9.6	NGUY_HIEM	10.77803	106.688289	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	2		29.6	78.9	2021	\N
61	TSK_017	6.8	SAU_BENH	10.774017	106.702407	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	2		20	55.3	2022	\N
62	TSK_018	8.8	TOT	10.774139	106.694731	Khu vực Trương Định - Nguyễn Thị Minh Khai (Q.1)	1		26.7	68	2024	\N
63	BS_001	11.6	TOT	10.755823	106.697276	Khu vực Bờ Sông Sài Gòn (Q.1)	1		35.7	90.2	2016	\N
64	BS_002	12.4	TOT	10.773848	106.712473	Khu vực Bờ Sông Sài Gòn (Q.1)	1		37.8	99.7	2012	\N
65	BS_003	4.3	TOT	10.756023	106.706899	Khu vực Bờ Sông Sài Gòn (Q.1)	1		13	29.4	2024	\N
66	BS_004	4.9	TOT	10.761155	106.695472	Khu vực Bờ Sông Sài Gòn (Q.1)	3		14.9	43.2	2021	\N
67	BS_005	14.4	TOT	10.759055	106.697782	Khu vực Bờ Sông Sài Gòn (Q.1)	1		44.6	117.3	2022	\N
68	BS_006	12.2	TOT	10.762035	106.695322	Khu vực Bờ Sông Sài Gòn (Q.1)	3		36.8	104.7	2019	\N
69	BS_007	9	NGUY_HIEM	10.755204	106.708889	Khu vực Bờ Sông Sài Gòn (Q.1)	1		27	67.5	2023	\N
70	BS_008	4.2	SAU_BENH	10.767902	106.698477	Khu vực Bờ Sông Sài Gòn (Q.1)	2		12.4	37.5	2023	\N
71	BS_009	10.1	TOT	10.771189	106.708068	Khu vực Bờ Sông Sài Gòn (Q.1)	1		30.6	83.9	2023	\N
72	BS_010	10.8	TOT	10.758244	106.705639	Khu vực Bờ Sông Sài Gòn (Q.1)	1		32.3	94.8	2017	\N
73	BS_011	7.4	TOT	10.763922	106.695942	Khu vực Bờ Sông Sài Gòn (Q.1)	1		22.9	58.1	2024	\N
74	BS_012	9.2	TOT	10.773062	106.703952	Khu vực Bờ Sông Sài Gòn (Q.1)	2		28.2	73.7	2024	\N
75	test001	0	TOT	10.82009572027356	106.60840988159181		1		1	1	2019	\N
76	test002	1	TOT	10.829369098740637	106.60909652709962		1		1	1	2022	\N
77	test003	1	TOT	10.837461999575996	106.59072875976564		1		1	1	2020	19
78	TEST004	5	TOT	10.82902398763751	106.61793708801271		1	tree_images/2020_l2Q7ura.png	5	5	2020	19
\.


--
-- TOC entry 5241 (class 0 OID 17942)
-- Dependencies: 255
-- Data for Name: public_map_urbantree_soil_qualities; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_urbantree_soil_qualities (id, urbantree_id, soilquality_id) FROM stdin;
1	76	1
2	77	1
3	78	1
\.


--
-- TOC entry 5245 (class 0 OID 17989)
-- Dependencies: 259
-- Data for Name: public_map_usermanageddistrict; Type: TABLE DATA; Schema: public; Owner: urbangreen_user
--

COPY public.public_map_usermanageddistrict (id, created_at, district_id, user_id) FROM stdin;
4	2026-04-15 13:03:32.446741+07	14	5
5	2026-04-15 13:04:36.873335+07	14	8
\.


--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 219
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 221
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 64, true);


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 227
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 225
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 8, true);


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 231
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 9, true);


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 233
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 16, true);


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 235
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 71, true);


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 248
-- Name: public_map_activitylog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_activitylog_id_seq', 12, true);


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 256
-- Name: public_map_district_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_district_id_seq', 22, true);


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 244
-- Name: public_map_maintenancelog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_maintenancelog_id_seq', 3, true);


--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 246
-- Name: public_map_managementzone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_managementzone_id_seq', 1, false);


--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 252
-- Name: public_map_soilquality_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_soilquality_id_seq', 3, true);


--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 250
-- Name: public_map_treeimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_treeimage_id_seq', 4, true);


--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 238
-- Name: public_map_treemetadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_treemetadata_id_seq', 1, false);


--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 240
-- Name: public_map_treespecies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_treespecies_id_seq', 1, true);


--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 242
-- Name: public_map_urbantree_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_urbantree_id_seq', 78, true);


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 254
-- Name: public_map_urbantree_soil_qualities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_urbantree_soil_qualities_id_seq', 3, true);


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 258
-- Name: public_map_usermanageddistrict_id_seq; Type: SEQUENCE SET; Schema: public; Owner: urbangreen_user
--

SELECT pg_catalog.setval('public.public_map_usermanageddistrict_id_seq', 5, true);


--
-- TOC entry 4971 (class 2606 OID 17389)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4969 (class 2606 OID 17379)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4973 (class 2606 OID 17402)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 4977 (class 2606 OID 17431)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4975 (class 2606 OID 17421)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4979 (class 2606 OID 17441)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4981 (class 2606 OID 17456)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4983 (class 2606 OID 17468)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4985 (class 2606 OID 17481)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4987 (class 2606 OID 17491)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 5007 (class 2606 OID 17899)
-- Name: public_map_activitylog public_map_activitylog_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_activitylog
    ADD CONSTRAINT public_map_activitylog_pkey PRIMARY KEY (id);


--
-- TOC entry 5028 (class 2606 OID 17982)
-- Name: public_map_district public_map_district_code_key; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_district
    ADD CONSTRAINT public_map_district_code_key UNIQUE (code);


--
-- TOC entry 5031 (class 2606 OID 17980)
-- Name: public_map_district public_map_district_name_key; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_district
    ADD CONSTRAINT public_map_district_name_key UNIQUE (name);


--
-- TOC entry 5033 (class 2606 OID 17978)
-- Name: public_map_district public_map_district_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_district
    ADD CONSTRAINT public_map_district_pkey PRIMARY KEY (id);


--
-- TOC entry 5002 (class 2606 OID 17850)
-- Name: public_map_maintenancelog public_map_maintenancelog_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_maintenancelog
    ADD CONSTRAINT public_map_maintenancelog_pkey PRIMARY KEY (id);


--
-- TOC entry 5005 (class 2606 OID 17885)
-- Name: public_map_managementzone public_map_managementzone_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_managementzone
    ADD CONSTRAINT public_map_managementzone_pkey PRIMARY KEY (id);


--
-- TOC entry 5014 (class 2606 OID 17938)
-- Name: public_map_soilquality public_map_soilquality_name_key; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_soilquality
    ADD CONSTRAINT public_map_soilquality_name_key UNIQUE (name);


--
-- TOC entry 5016 (class 2606 OID 17936)
-- Name: public_map_soilquality public_map_soilquality_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_soilquality
    ADD CONSTRAINT public_map_soilquality_pkey PRIMARY KEY (id);


--
-- TOC entry 5019 (class 2606 OID 17940)
-- Name: public_map_soilquality public_map_soilquality_soil_type_key; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_soilquality
    ADD CONSTRAINT public_map_soilquality_soil_type_key UNIQUE (soil_type);


--
-- TOC entry 5010 (class 2606 OID 17916)
-- Name: public_map_treeimage public_map_treeimage_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_treeimage
    ADD CONSTRAINT public_map_treeimage_pkey PRIMARY KEY (id);


--
-- TOC entry 4989 (class 2606 OID 17674)
-- Name: public_map_treemetadata public_map_treemetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_treemetadata
    ADD CONSTRAINT public_map_treemetadata_pkey PRIMARY KEY (id);


--
-- TOC entry 4991 (class 2606 OID 17676)
-- Name: public_map_treemetadata public_map_treemetadata_tree_id_key; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_treemetadata
    ADD CONSTRAINT public_map_treemetadata_tree_id_key UNIQUE (tree_id);


--
-- TOC entry 4993 (class 2606 OID 17813)
-- Name: public_map_treespecies public_map_treespecies_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_treespecies
    ADD CONSTRAINT public_map_treespecies_pkey PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 17829)
-- Name: public_map_urbantree public_map_urbantree_code_key; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_urbantree
    ADD CONSTRAINT public_map_urbantree_code_key UNIQUE (code);


--
-- TOC entry 4999 (class 2606 OID 17827)
-- Name: public_map_urbantree public_map_urbantree_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_urbantree
    ADD CONSTRAINT public_map_urbantree_pkey PRIMARY KEY (id);


--
-- TOC entry 5021 (class 2606 OID 17953)
-- Name: public_map_urbantree_soil_qualities public_map_urbantree_soi_urbantree_id_soilquality_f88b9084_uniq; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_urbantree_soil_qualities
    ADD CONSTRAINT public_map_urbantree_soi_urbantree_id_soilquality_f88b9084_uniq UNIQUE (urbantree_id, soilquality_id);


--
-- TOC entry 5023 (class 2606 OID 17949)
-- Name: public_map_urbantree_soil_qualities public_map_urbantree_soil_qualities_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_urbantree_soil_qualities
    ADD CONSTRAINT public_map_urbantree_soil_qualities_pkey PRIMARY KEY (id);


--
-- TOC entry 5035 (class 2606 OID 18002)
-- Name: public_map_usermanageddistrict public_map_usermanageddi_user_id_district_id_07260022_uniq; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_usermanageddistrict
    ADD CONSTRAINT public_map_usermanageddi_user_id_district_id_07260022_uniq UNIQUE (user_id, district_id);


--
-- TOC entry 5038 (class 2606 OID 17997)
-- Name: public_map_usermanageddistrict public_map_usermanageddistrict_pkey; Type: CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_usermanageddistrict
    ADD CONSTRAINT public_map_usermanageddistrict_pkey PRIMARY KEY (id);


--
-- TOC entry 5008 (class 1259 OID 17905)
-- Name: public_map_activitylog_user_id_9ccfc863; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_activitylog_user_id_9ccfc863 ON public.public_map_activitylog USING btree (user_id);


--
-- TOC entry 5026 (class 1259 OID 17999)
-- Name: public_map_district_code_18407487_like; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_district_code_18407487_like ON public.public_map_district USING btree (code varchar_pattern_ops);


--
-- TOC entry 5029 (class 1259 OID 17998)
-- Name: public_map_district_name_9507a9b8_like; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_district_name_9507a9b8_like ON public.public_map_district USING btree (name varchar_pattern_ops);


--
-- TOC entry 5003 (class 1259 OID 17856)
-- Name: public_map_maintenancelog_tree_id_e704a168; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_maintenancelog_tree_id_e704a168 ON public.public_map_maintenancelog USING btree (tree_id);


--
-- TOC entry 5012 (class 1259 OID 17950)
-- Name: public_map_soilquality_name_09f0d4a6_like; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_soilquality_name_09f0d4a6_like ON public.public_map_soilquality USING btree (name varchar_pattern_ops);


--
-- TOC entry 5017 (class 1259 OID 17951)
-- Name: public_map_soilquality_soil_type_d1492253_like; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_soilquality_soil_type_d1492253_like ON public.public_map_soilquality USING btree (soil_type varchar_pattern_ops);


--
-- TOC entry 5011 (class 1259 OID 17922)
-- Name: public_map_treeimage_tree_id_01f49e86; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_treeimage_tree_id_01f49e86 ON public.public_map_treeimage USING btree (tree_id);


--
-- TOC entry 4994 (class 1259 OID 17835)
-- Name: public_map_urbantree_code_c956cd23_like; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_urbantree_code_c956cd23_like ON public.public_map_urbantree USING btree (code varchar_pattern_ops);


--
-- TOC entry 4997 (class 1259 OID 18000)
-- Name: public_map_urbantree_district_id_bbbda302; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_urbantree_district_id_bbbda302 ON public.public_map_urbantree USING btree (district_id);


--
-- TOC entry 5024 (class 1259 OID 17965)
-- Name: public_map_urbantree_soil_qualities_soilquality_id_0e65c71c; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_urbantree_soil_qualities_soilquality_id_0e65c71c ON public.public_map_urbantree_soil_qualities USING btree (soilquality_id);


--
-- TOC entry 5025 (class 1259 OID 17964)
-- Name: public_map_urbantree_soil_qualities_urbantree_id_d93aa0fb; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_urbantree_soil_qualities_urbantree_id_d93aa0fb ON public.public_map_urbantree_soil_qualities USING btree (urbantree_id);


--
-- TOC entry 5000 (class 1259 OID 17836)
-- Name: public_map_urbantree_species_id_034b8c15; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_urbantree_species_id_034b8c15 ON public.public_map_urbantree USING btree (species_id);


--
-- TOC entry 5036 (class 1259 OID 18013)
-- Name: public_map_usermanageddistrict_district_id_52367220; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_usermanageddistrict_district_id_52367220 ON public.public_map_usermanageddistrict USING btree (district_id);


--
-- TOC entry 5039 (class 1259 OID 18014)
-- Name: public_map_usermanageddistrict_user_id_bde29294; Type: INDEX; Schema: public; Owner: urbangreen_user
--

CREATE INDEX public_map_usermanageddistrict_user_id_bde29294 ON public.public_map_usermanageddistrict USING btree (user_id);


--
-- TOC entry 5040 (class 2606 OID 17572)
-- Name: auth_group_permissions auth_group_permissions_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_fk_0 FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id);


--
-- TOC entry 5041 (class 2606 OID 17577)
-- Name: auth_group_permissions auth_group_permissions_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_fk_1 FOREIGN KEY (group_id) REFERENCES public.auth_group(id);


--
-- TOC entry 5042 (class 2606 OID 17582)
-- Name: auth_permission auth_permission_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_fk_0 FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id);


--
-- TOC entry 5043 (class 2606 OID 17587)
-- Name: auth_user_groups auth_user_groups_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_fk_0 FOREIGN KEY (group_id) REFERENCES public.auth_group(id);


--
-- TOC entry 5044 (class 2606 OID 17592)
-- Name: auth_user_groups auth_user_groups_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_fk_1 FOREIGN KEY (user_id) REFERENCES public.auth_user(id);


--
-- TOC entry 5045 (class 2606 OID 17597)
-- Name: auth_user_user_permissions auth_user_user_permissions_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_fk_0 FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id);


--
-- TOC entry 5046 (class 2606 OID 17602)
-- Name: auth_user_user_permissions auth_user_user_permissions_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_fk_1 FOREIGN KEY (user_id) REFERENCES public.auth_user(id);


--
-- TOC entry 5047 (class 2606 OID 17607)
-- Name: django_admin_log django_admin_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_fk_0 FOREIGN KEY (user_id) REFERENCES public.auth_user(id);


--
-- TOC entry 5048 (class 2606 OID 17612)
-- Name: django_admin_log django_admin_log_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_fk_1 FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id);


--
-- TOC entry 5052 (class 2606 OID 17900)
-- Name: public_map_activitylog public_map_activitylog_user_id_9ccfc863_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_activitylog
    ADD CONSTRAINT public_map_activitylog_user_id_9ccfc863_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5051 (class 2606 OID 17851)
-- Name: public_map_maintenancelog public_map_maintenan_tree_id_e704a168_fk_public_ma; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_maintenancelog
    ADD CONSTRAINT public_map_maintenan_tree_id_e704a168_fk_public_ma FOREIGN KEY (tree_id) REFERENCES public.public_map_urbantree(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5053 (class 2606 OID 17917)
-- Name: public_map_treeimage public_map_treeimage_tree_id_01f49e86_fk_public_ma; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_treeimage
    ADD CONSTRAINT public_map_treeimage_tree_id_01f49e86_fk_public_ma FOREIGN KEY (tree_id) REFERENCES public.public_map_urbantree(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5049 (class 2606 OID 17983)
-- Name: public_map_urbantree public_map_urbantree_district_id_bbbda302_fk_public_ma; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_urbantree
    ADD CONSTRAINT public_map_urbantree_district_id_bbbda302_fk_public_ma FOREIGN KEY (district_id) REFERENCES public.public_map_district(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5054 (class 2606 OID 17959)
-- Name: public_map_urbantree_soil_qualities public_map_urbantree_soilquality_id_0e65c71c_fk_public_ma; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_urbantree_soil_qualities
    ADD CONSTRAINT public_map_urbantree_soilquality_id_0e65c71c_fk_public_ma FOREIGN KEY (soilquality_id) REFERENCES public.public_map_soilquality(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5050 (class 2606 OID 17830)
-- Name: public_map_urbantree public_map_urbantree_species_id_034b8c15_fk_public_ma; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_urbantree
    ADD CONSTRAINT public_map_urbantree_species_id_034b8c15_fk_public_ma FOREIGN KEY (species_id) REFERENCES public.public_map_treespecies(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5055 (class 2606 OID 17954)
-- Name: public_map_urbantree_soil_qualities public_map_urbantree_urbantree_id_d93aa0fb_fk_public_ma; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_urbantree_soil_qualities
    ADD CONSTRAINT public_map_urbantree_urbantree_id_d93aa0fb_fk_public_ma FOREIGN KEY (urbantree_id) REFERENCES public.public_map_urbantree(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5056 (class 2606 OID 18003)
-- Name: public_map_usermanageddistrict public_map_usermanag_district_id_52367220_fk_public_ma; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_usermanageddistrict
    ADD CONSTRAINT public_map_usermanag_district_id_52367220_fk_public_ma FOREIGN KEY (district_id) REFERENCES public.public_map_district(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5057 (class 2606 OID 18008)
-- Name: public_map_usermanageddistrict public_map_usermanageddistrict_user_id_bde29294_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: urbangreen_user
--

ALTER TABLE ONLY public.public_map_usermanageddistrict
    ADD CONSTRAINT public_map_usermanageddistrict_user_id_bde29294_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO urbangreen_user;


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE auth_group; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_group TO urbangreen_user;


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE auth_group_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_group_id_seq TO urbangreen_user;


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE auth_group_permissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_group_permissions TO urbangreen_user;


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE auth_group_permissions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_group_permissions_id_seq TO urbangreen_user;


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE auth_permission; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_permission TO urbangreen_user;


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE auth_permission_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_permission_id_seq TO urbangreen_user;


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE auth_user; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_user TO urbangreen_user;


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE auth_user_groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_user_groups TO urbangreen_user;


--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE auth_user_groups_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_user_groups_id_seq TO urbangreen_user;


--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE auth_user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_user_id_seq TO urbangreen_user;


--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE auth_user_user_permissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auth_user_user_permissions TO urbangreen_user;


--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE auth_user_user_permissions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auth_user_user_permissions_id_seq TO urbangreen_user;


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE django_admin_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.django_admin_log TO urbangreen_user;


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE django_admin_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.django_admin_log_id_seq TO urbangreen_user;


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE django_content_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.django_content_type TO urbangreen_user;


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 233
-- Name: SEQUENCE django_content_type_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.django_content_type_id_seq TO urbangreen_user;


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE django_migrations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.django_migrations TO urbangreen_user;


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 235
-- Name: SEQUENCE django_migrations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.django_migrations_id_seq TO urbangreen_user;


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE django_session; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.django_session TO urbangreen_user;


--
-- TOC entry 2152 (class 826 OID 17634)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO urbangreen_user;


--
-- TOC entry 2151 (class 826 OID 17633)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO urbangreen_user;


-- Completed on 2026-05-04 04:04:45

--
-- PostgreSQL database dump complete
--

\unrestrict limN9ncJ0ZbjzZF9UQcds9LKqEvz5hfYFDnsjzuUTNUU0mZC9WXYgojErU0XGA4

