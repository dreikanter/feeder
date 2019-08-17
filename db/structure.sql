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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blocked_ips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blocked_ips (
    id bigint NOT NULL,
    ip inet NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: blocked_ips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blocked_ips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blocked_ips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blocked_ips_id_seq OWNED BY public.blocked_ips.id;


--
-- Name: data_point_series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_point_series (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: data_point_series_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_point_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_point_series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_point_series_id_seq OWNED BY public.data_point_series.id;


--
-- Name: data_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_points (
    id integer NOT NULL,
    series_id integer,
    details json DEFAULT '{}'::json NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: data_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_points_id_seq OWNED BY public.data_points.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delayed_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delayed_jobs_id_seq OWNED BY public.delayed_jobs.id;


--
-- Name: errors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.errors (
    id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    exception character varying DEFAULT ''::character varying NOT NULL,
    file_name character varying,
    line_number integer,
    label character varying DEFAULT ''::character varying NOT NULL,
    message character varying DEFAULT ''::character varying NOT NULL,
    backtrace character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    context json DEFAULT '{}'::json NOT NULL,
    occured_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    target_type character varying,
    target_id bigint
);


--
-- Name: errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.errors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.errors_id_seq OWNED BY public.errors.id;


--
-- Name: feeds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feeds (
    id integer NOT NULL,
    name character varying NOT NULL,
    posts_count integer DEFAULT 0 NOT NULL,
    refreshed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    url character varying,
    processor character varying,
    normalizer character varying,
    after timestamp without time zone,
    refresh_interval integer DEFAULT 0 NOT NULL,
    options json DEFAULT '{}'::json NOT NULL,
    loader character varying,
    import_limit integer,
    last_post_created_at timestamp without time zone,
    subscriptions_count integer DEFAULT 0 NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


--
-- Name: feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feeds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feeds_id_seq OWNED BY public.feeds.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    feed_id integer NOT NULL,
    link character varying NOT NULL,
    published_at timestamp without time zone NOT NULL,
    text character varying DEFAULT ''::character varying NOT NULL,
    attachments character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    comments character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    freefeed_post_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    uid character varying NOT NULL
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: blocked_ips id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocked_ips ALTER COLUMN id SET DEFAULT nextval('public.blocked_ips_id_seq'::regclass);


--
-- Name: data_point_series id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_point_series ALTER COLUMN id SET DEFAULT nextval('public.data_point_series_id_seq'::regclass);


--
-- Name: data_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_points ALTER COLUMN id SET DEFAULT nextval('public.data_points_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: errors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.errors ALTER COLUMN id SET DEFAULT nextval('public.errors_id_seq'::regclass);


--
-- Name: feeds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeds ALTER COLUMN id SET DEFAULT nextval('public.feeds_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blocked_ips blocked_ips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocked_ips
    ADD CONSTRAINT blocked_ips_pkey PRIMARY KEY (id);


--
-- Name: data_point_series data_point_series_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_point_series
    ADD CONSTRAINT data_point_series_pkey PRIMARY KEY (id);


--
-- Name: data_points data_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_points
    ADD CONSTRAINT data_points_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: errors errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.errors
    ADD CONSTRAINT errors_pkey PRIMARY KEY (id);


--
-- Name: feeds feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: index_blocked_ips_on_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_blocked_ips_on_ip ON public.blocked_ips USING btree (ip);


--
-- Name: index_data_point_series_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_data_point_series_on_name ON public.data_point_series USING btree (name);


--
-- Name: index_data_points_on_series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_points_on_series_id ON public.data_points USING btree (series_id);


--
-- Name: index_errors_on_exception; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_errors_on_exception ON public.errors USING btree (exception);


--
-- Name: index_errors_on_file_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_errors_on_file_name ON public.errors USING btree (file_name);


--
-- Name: index_errors_on_occured_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_errors_on_occured_at ON public.errors USING btree (occured_at);


--
-- Name: index_errors_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_errors_on_status ON public.errors USING btree (status);


--
-- Name: index_errors_on_target_type_and_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_errors_on_target_type_and_target_id ON public.errors USING btree (target_type, target_id);


--
-- Name: index_feeds_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_feeds_on_name ON public.feeds USING btree (name);


--
-- Name: index_feeds_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feeds_on_status ON public.feeds USING btree (status);


--
-- Name: index_posts_on_feed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_feed_id ON public.posts USING btree (feed_id);


--
-- Name: index_posts_on_link; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_link ON public.posts USING btree (link);


--
-- Name: index_posts_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_status ON public.posts USING btree (status);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160912105557'),
('20160912110133'),
('20160913121434'),
('20160920171420'),
('20160920171429'),
('20160926170407'),
('20160926234238'),
('20160929123932'),
('20170308200158'),
('20180520150306'),
('20181029160355'),
('20181126110206'),
('20181126152746'),
('20181126170638'),
('20181126194822'),
('20190609193619'),
('20190624150553'),
('20190701101346'),
('20190726193542'),
('20190817114629');


