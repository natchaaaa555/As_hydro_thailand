CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE basins (
    basin_id SERIAL PRIMARY KEY,
    basin_name VARCHAR(100) NOT NULL,
    manning_n FLOAT DEFAULT 0.035,
    decay_rate FLOAT DEFAULT 0.015
);

CREATE TABLE river_nodes (
    node_id INT PRIMARY KEY,
    basin_id INT REFERENCES basins(basin_id),
    station_name VARCHAR(150) NOT NULL,
    geom GEOMETRY(Point, 4326) NOT NULL,
    distance_km FLOAT NOT NULL,
    slope FLOAT NOT NULL
);

CREATE TABLE river_edges (
    edge_id SERIAL PRIMARY KEY,
    source_node INT REFERENCES river_nodes(node_id),
    target_node INT REFERENCES river_nodes(node_id),
    length_km FLOAT NOT NULL
);

INSERT INTO basins (basin_id, basin_name, manning_n, decay_rate) 
VALUES (1, 'ลุ่มน้ำโขงเหนือ (แม่น้ำสาย - แม่น้ำรวก)', 0.035, 0.015);

INSERT INTO river_nodes (node_id, basin_id, station_name, geom, distance_km, slope) VALUES
(0, 1, 'ต้นน้ำแม่น้ำสาย (เหนือพรมแดน)', ST_SetSRID(ST_MakePoint(99.8512, 20.4680), 4326), 0.0, 0.0025),
(1, 1, 'ชุมชนสายลมจอย', ST_SetSRID(ST_MakePoint(99.8785, 20.4435), 4326), 12.0, 0.0015),
(2, 1, 'สะพานมิตรภาพฯ แห่งที่ 1', ST_SetSRID(ST_MakePoint(99.8801, 20.4422), 4326), 13.5, 0.0012),
(3, 1, 'สะพานมิตรภาพฯ แห่งที่ 2', ST_SetSRID(ST_MakePoint(99.9045, 20.4310), 4326), 17.5, 0.0009),
(4, 1, 'จุดบรรจบแม่น้ำรวก (Confluence)', ST_SetSRID(ST_MakePoint(100.0520, 20.3650), 4326), 28.0, 0.0006),
(5, 1, 'สามเหลี่ยมทองคำ (แม่น้ำโขง)', ST_SetSRID(ST_MakePoint(100.0825, 20.3522), 4326), 34.0, 0.0004);

INSERT INTO river_edges (source_node, target_node, length_km) VALUES
(0, 1, 12.0), (1, 2, 1.5), (2, 3, 4.0), (3, 4, 10.5), (4, 5, 6.0);