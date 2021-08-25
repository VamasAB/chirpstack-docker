--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.13
-- Dumped by pg_dump version 9.6.13

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

--CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

--COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

--CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

--COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: device_ack; Type: TABLE; Schema: public; Owner: chirpstack_lorastore
--

CREATE TABLE public.device_ack (
    id uuid NOT NULL,
    received_at timestamp with time zone NOT NULL,
    dev_eui bytea NOT NULL,
    device_name character varying(100) NOT NULL,
    application_id bigint NOT NULL,
    application_name character varying(100) NOT NULL,
    acknowledged boolean NOT NULL,
    f_cnt bigint NOT NULL,
    tags public.hstore NOT NULL
);


ALTER TABLE public.device_ack OWNER TO chirpstack_lorastore;

--
-- Name: device_error; Type: TABLE; Schema: public; Owner: chirpstack_lorastore
--

CREATE TABLE public.device_error (
    id uuid NOT NULL,
    received_at timestamp with time zone NOT NULL,
    dev_eui bytea NOT NULL,
    device_name character varying(100) NOT NULL,
    application_id bigint NOT NULL,
    application_name character varying(100) NOT NULL,
    type character varying(100) NOT NULL,
    error text NOT NULL,
    f_cnt bigint NOT NULL,
    tags public.hstore NOT NULL
);


ALTER TABLE public.device_error OWNER TO chirpstack_lorastore;

--
-- Name: device_join; Type: TABLE; Schema: public; Owner: chirpstack_lorastore
--

CREATE TABLE public.device_join (
    id uuid NOT NULL,
    received_at timestamp with time zone NOT NULL,
    dev_eui bytea NOT NULL,
    device_name character varying(100) NOT NULL,
    application_id bigint NOT NULL,
    application_name character varying(100) NOT NULL,
    dev_addr bytea NOT NULL,
    tags public.hstore NOT NULL
);


ALTER TABLE public.device_join OWNER TO chirpstack_lorastore;

--
-- Name: device_location; Type: TABLE; Schema: public; Owner: chirpstack_lorastore
--

CREATE TABLE public.device_location (
    id uuid NOT NULL,
    received_at timestamp with time zone NOT NULL,
    dev_eui bytea NOT NULL,
    device_name character varying(100) NOT NULL,
    application_id bigint NOT NULL,
    application_name character varying(100) NOT NULL,
    altitude double precision NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    geohash character varying(12) NOT NULL,
    tags public.hstore NOT NULL,
    accuracy smallint NOT NULL
);


ALTER TABLE public.device_location OWNER TO chirpstack_lorastore;

--
-- Name: device_status; Type: TABLE; Schema: public; Owner: chirpstack_lorastore
--

CREATE TABLE public.device_status (
    id uuid NOT NULL,
    received_at timestamp with time zone NOT NULL,
    dev_eui bytea NOT NULL,
    device_name character varying(100) NOT NULL,
    application_id bigint NOT NULL,
    application_name character varying(100) NOT NULL,
    margin smallint NOT NULL,
    external_power_source boolean NOT NULL,
    battery_level_unavailable boolean NOT NULL,
    battery_level numeric(5,2) NOT NULL,
    tags public.hstore NOT NULL
);


ALTER TABLE public.device_status OWNER TO chirpstack_lorastore;

--
-- Name: device_up; Type: TABLE; Schema: public; Owner: chirpstack_lorastore
--

CREATE TABLE public.device_up (
    id uuid NOT NULL,
    received_at timestamp with time zone NOT NULL,
    dev_eui bytea NOT NULL,
    device_name character varying(100) NOT NULL,
    application_id bigint NOT NULL,
    application_name character varying(100) NOT NULL,
    frequency bigint NOT NULL,
    dr smallint NOT NULL,
    adr boolean NOT NULL,
    f_cnt bigint NOT NULL,
    f_port smallint NOT NULL,
    tags public.hstore NOT NULL,
    data bytea NOT NULL,
    rx_info jsonb NOT NULL,
    object jsonb NOT NULL
);


ALTER TABLE public.device_up OWNER TO chirpstack_lorastore;

--
-- Name: device_ack device_ack_pkey; Type: CONSTRAINT; Schema: public; Owner: chirpstack_lorastore
--

ALTER TABLE ONLY public.device_ack
    ADD CONSTRAINT device_ack_pkey PRIMARY KEY (id);


--
-- Name: device_error device_error_pkey; Type: CONSTRAINT; Schema: public; Owner: chirpstack_lorastore
--

ALTER TABLE ONLY public.device_error
    ADD CONSTRAINT device_error_pkey PRIMARY KEY (id);


--
-- Name: device_join device_join_pkey; Type: CONSTRAINT; Schema: public; Owner: chirpstack_lorastore
--

ALTER TABLE ONLY public.device_join
    ADD CONSTRAINT device_join_pkey PRIMARY KEY (id);


--
-- Name: device_location device_location_pkey; Type: CONSTRAINT; Schema: public; Owner: chirpstack_lorastore
--

ALTER TABLE ONLY public.device_location
    ADD CONSTRAINT device_location_pkey PRIMARY KEY (id);


--
-- Name: device_status device_status_pkey; Type: CONSTRAINT; Schema: public; Owner: chirpstack_lorastore
--

ALTER TABLE ONLY public.device_status
    ADD CONSTRAINT device_status_pkey PRIMARY KEY (id);


--
-- Name: device_up device_up_pkey; Type: CONSTRAINT; Schema: public; Owner: chirpstack_lorastore
--

ALTER TABLE ONLY public.device_up
    ADD CONSTRAINT device_up_pkey PRIMARY KEY (id);


--
-- Name: idx_device_ack_application_id; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_ack_application_id ON public.device_ack USING btree (application_id);


--
-- Name: idx_device_ack_dev_eui; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_ack_dev_eui ON public.device_ack USING btree (dev_eui);


--
-- Name: idx_device_ack_received_at; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_ack_received_at ON public.device_ack USING btree (received_at);


--
-- Name: idx_device_ack_tags; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_ack_tags ON public.device_ack USING btree (tags);


--
-- Name: idx_device_error_application_id; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_error_application_id ON public.device_error USING btree (application_id);


--
-- Name: idx_device_error_dev_eui; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_error_dev_eui ON public.device_error USING btree (dev_eui);


--
-- Name: idx_device_error_received_at; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_error_received_at ON public.device_error USING btree (received_at);


--
-- Name: idx_device_error_tags; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_error_tags ON public.device_error USING btree (tags);


--
-- Name: idx_device_join_application_id; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_join_application_id ON public.device_join USING btree (application_id);


--
-- Name: idx_device_join_dev_eui; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_join_dev_eui ON public.device_join USING btree (dev_eui);


--
-- Name: idx_device_join_received_at; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_join_received_at ON public.device_join USING btree (received_at);


--
-- Name: idx_device_join_tags; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_join_tags ON public.device_join USING btree (tags);


--
-- Name: idx_device_location_application_id; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_location_application_id ON public.device_location USING btree (application_id);


--
-- Name: idx_device_location_dev_eui; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_location_dev_eui ON public.device_location USING btree (dev_eui);


--
-- Name: idx_device_location_received_at; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_location_received_at ON public.device_location USING btree (received_at);


--
-- Name: idx_device_location_tags; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_location_tags ON public.device_location USING btree (tags);


--
-- Name: idx_device_status_application_id; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_status_application_id ON public.device_status USING btree (application_id);


--
-- Name: idx_device_status_dev_eui; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_status_dev_eui ON public.device_status USING btree (dev_eui);


--
-- Name: idx_device_status_received_at; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_status_received_at ON public.device_status USING btree (received_at);


--
-- Name: idx_device_status_tags; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_status_tags ON public.device_status USING btree (tags);


--
-- Name: idx_device_up_application_id; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_up_application_id ON public.device_up USING btree (application_id);


--
-- Name: idx_device_up_dev_eui; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_up_dev_eui ON public.device_up USING btree (dev_eui);


--
-- Name: idx_device_up_dr; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_up_dr ON public.device_up USING btree (dr);


--
-- Name: idx_device_up_frequency; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_up_frequency ON public.device_up USING btree (frequency);


--
-- Name: idx_device_up_received_at; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_up_received_at ON public.device_up USING btree (received_at);


--
-- Name: idx_device_up_tags; Type: INDEX; Schema: public; Owner: chirpstack_lorastore
--

CREATE INDEX idx_device_up_tags ON public.device_up USING btree (tags);


--
-- PostgreSQL database dump complete
--