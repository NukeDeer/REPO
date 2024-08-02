USE [Space_Guru_Challenge]
GO
/****** Object:  Table [dbo].[user_types]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_types](
	[user_type_id] [int] IDENTITY(1,1) NOT NULL,
	[user_type_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_user_types] PRIMARY KEY CLUSTERED 
(
	[user_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_type_id] [int] NOT NULL,
	[username] [varchar](100) NOT NULL,
	[password_hash] [varchar](500) NOT NULL,
	[firstname] [varchar](200) NULL,
	[lastname] [varchar](200) NULL,
	[email] [varchar](200) NULL,
	[phone_number] [varchar](100) NULL,
	[phone_number_country_code] [varchar](10) NULL,
	[address] [varchar](200) NULL,
	[license_id] [int] NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NULL,
	[dalete_date] [datetime] NULL,
	[deleted_flag] [bit] NOT NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rides]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rides](
	[ride_id] [int] IDENTITY(1,1) NOT NULL,
	[user_driver_id] [int] NOT NULL,
	[order_id] [int] NOT NULL,
	[status_id] [int] NOT NULL,
	[start_location] [varchar](300) NOT NULL,
	[end_location] [varchar](300) NOT NULL,
	[current_location] [varchar](300) NULL,
	[start_datetime] [datetime] NOT NULL,
	[end_datetime] [datetime] NOT NULL,
 CONSTRAINT [PK_rides] PRIMARY KEY CLUSTERED 
(
	[ride_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[licenses]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[licenses](
	[license_id] [int] IDENTITY(1,1) NOT NULL,
	[license_number] [varchar](200) NOT NULL,
	[license_type] [varchar](50) NOT NULL,
	[issue_city_id] [int] NULL,
	[issue_date] [date] NOT NULL,
	[expiration_date] [date] NOT NULL,
	[fistname] [varchar](200) NULL,
	[lastname] [varchar](200) NULL,
	[birthdate] [date] NULL,
	[address] [varchar](200) NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NULL,
	[delete_date] [datetime] NULL,
	[deleted_flag] [bit] NOT NULL,
 CONSTRAINT [PK_licenses] PRIMARY KEY CLUSTERED 
(
	[license_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_conductores_disponibles]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[view_conductores_disponibles] AS
SELECT 
        user_id, 
        user_types.user_type_id, 
        user_types.user_type_name, 
        username,
        users.firstname, 
        users.lastname, 
        email, 
        phone_number, 
        phone_number_country_code, 
        users.address, 
        license_number, 
        license_type,
		issue_date,
		expiration_date,
		licenses.fistname as license_first_name,
		licenses.lastname as license_last_name,
		licenses.address as license_address,
		licenses.birthdate as license_birthdate

FROM 
    users
JOIN
	licenses ON users.license_id = licenses.license_id	-- No apareceran aquellos usuarios que no tengan asociado una licencia de conducir
JOIN 
    user_types ON users.user_type_id = user_types.user_type_id

WHERE 
    user_types.user_type_id = 3
	AND users.deleted_flag = 0
    AND users.user_id NOT IN (
        SELECT 
            rides.user_driver_id
        FROM 
            rides
        WHERE 
            rides.status_id IN (1, 2)
    )
GO
/****** Object:  Table [dbo].[orders]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[request_user_id] [int] NOT NULL,
 CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permission_roles]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permission_roles](
	[permission_role_id] [int] IDENTITY(1,1) NOT NULL,
	[permission_role_name] [varchar](200) NOT NULL,
	[permission_role_description] [varchar](500) NULL,
 CONSTRAINT [PK_permission_roles] PRIMARY KEY CLUSTERED 
(
	[permission_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ride_status]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ride_status](
	[ride_status_id] [int] NOT NULL,
	[ride_status_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ride_status] PRIMARY KEY CLUSTERED 
(
	[ride_status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_type_roles]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_type_roles](
	[user_type_role_id] [int] IDENTITY(1,1) NOT NULL,
	[user_type_id] [int] NOT NULL,
	[permission_role_id] [int] NOT NULL,
 CONSTRAINT [PK_user_type_roles] PRIMARY KEY CLUSTERED 
(
	[user_type_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[licenses] ON 

INSERT [dbo].[licenses] ([license_id], [license_number], [license_type], [issue_city_id], [issue_date], [expiration_date], [fistname], [lastname], [birthdate], [address], [create_date], [modify_date], [delete_date], [deleted_flag]) VALUES (1, N'1111111111', N'A2', NULL, CAST(N'2023-01-01' AS Date), CAST(N'2025-01-01' AS Date), NULL, NULL, NULL, NULL, CAST(N'2024-07-31T00:00:00.000' AS DateTime), NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[licenses] OFF
GO
SET IDENTITY_INSERT [dbo].[orders] ON 

INSERT [dbo].[orders] ([order_id], [request_user_id]) VALUES (1, 5)
INSERT [dbo].[orders] ([order_id], [request_user_id]) VALUES (2, 5)
INSERT [dbo].[orders] ([order_id], [request_user_id]) VALUES (3, 5)
INSERT [dbo].[orders] ([order_id], [request_user_id]) VALUES (4, 1)
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
SET IDENTITY_INSERT [dbo].[permission_roles] ON 

INSERT [dbo].[permission_roles] ([permission_role_id], [permission_role_name], [permission_role_description]) VALUES (1, N'SYSTEM_ADMINISTRATOR', N'Rol ampio para administrador de sistema')
INSERT [dbo].[permission_roles] ([permission_role_id], [permission_role_name], [permission_role_description]) VALUES (2, N'USER_ADMINISTRATOR', N'Rol amplio para administrar modulo de usuarios')
INSERT [dbo].[permission_roles] ([permission_role_id], [permission_role_name], [permission_role_description]) VALUES (3, N'VIAJE_ADMINISTRATOR', N'Rol amplio de administracion de viajes')
INSERT [dbo].[permission_roles] ([permission_role_id], [permission_role_name], [permission_role_description]) VALUES (4, N'ACEPTAR_VIAJES', N'Permite aceptar viajes disponibles')
INSERT [dbo].[permission_roles] ([permission_role_id], [permission_role_name], [permission_role_description]) VALUES (5, N'VISUALIZA_VIAJES_DISPONIBLES', N'Permite visualizar los viajes disponibles')
INSERT [dbo].[permission_roles] ([permission_role_id], [permission_role_name], [permission_role_description]) VALUES (6, N'SOLICITAR_VIAJE', N'Permite solicitar un viaje')
INSERT [dbo].[permission_roles] ([permission_role_id], [permission_role_name], [permission_role_description]) VALUES (7, N'CANCELAR_VIAJE', N'Permite cancelar un viaje activo')
INSERT [dbo].[permission_roles] ([permission_role_id], [permission_role_name], [permission_role_description]) VALUES (8, N'FINALIZAR_VIAJE', N'Permite finalizar un viaje')
SET IDENTITY_INSERT [dbo].[permission_roles] OFF
GO
INSERT [dbo].[ride_status] ([ride_status_id], [ride_status_name]) VALUES (1, N'Creado')
INSERT [dbo].[ride_status] ([ride_status_id], [ride_status_name]) VALUES (2, N'En camino')
INSERT [dbo].[ride_status] ([ride_status_id], [ride_status_name]) VALUES (3, N'Finalizado')
INSERT [dbo].[ride_status] ([ride_status_id], [ride_status_name]) VALUES (4, N'Cancelado')
GO
SET IDENTITY_INSERT [dbo].[rides] ON 

INSERT [dbo].[rides] ([ride_id], [user_driver_id], [order_id], [status_id], [start_location], [end_location], [current_location], [start_datetime], [end_datetime]) VALUES (2, 6, 1, 1, N'-34.603689, -58.381680', N'-34.603689, -58.381680', N'-34.603689, -58.381680', CAST(N'2024-07-31T00:00:00.000' AS DateTime), CAST(N'2024-08-01T00:00:00.000' AS DateTime))
INSERT [dbo].[rides] ([ride_id], [user_driver_id], [order_id], [status_id], [start_location], [end_location], [current_location], [start_datetime], [end_datetime]) VALUES (3, 6, 2, 2, N'-34.603689, -58.381680', N'-34.603689, -58.381680', N'-34.603689, -58.381680', CAST(N'2024-07-31T00:00:00.000' AS DateTime), CAST(N'2024-08-01T00:00:00.000' AS DateTime))
INSERT [dbo].[rides] ([ride_id], [user_driver_id], [order_id], [status_id], [start_location], [end_location], [current_location], [start_datetime], [end_datetime]) VALUES (4, 6, 3, 3, N'-34.603689, -58.381680', N'-34.603689, -58.381680', N'-34.603689, -58.381680', CAST(N'2024-07-31T00:00:00.000' AS DateTime), CAST(N'2024-08-01T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[rides] OFF
GO
SET IDENTITY_INSERT [dbo].[user_type_roles] ON 

INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (1, 1, 1)
INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (2, 1, 2)
INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (3, 1, 3)
INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (4, 3, 4)
INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (5, 3, 5)
INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (6, 3, 7)
INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (7, 3, 8)
INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (8, 2, 6)
INSERT [dbo].[user_type_roles] ([user_type_role_id], [user_type_id], [permission_role_id]) VALUES (9, 2, 7)
SET IDENTITY_INSERT [dbo].[user_type_roles] OFF
GO
SET IDENTITY_INSERT [dbo].[user_types] ON 

INSERT [dbo].[user_types] ([user_type_id], [user_type_name]) VALUES (1, N'Administrador')
INSERT [dbo].[user_types] ([user_type_id], [user_type_name]) VALUES (2, N'Cliente')
INSERT [dbo].[user_types] ([user_type_id], [user_type_name]) VALUES (3, N'Conductor')
SET IDENTITY_INSERT [dbo].[user_types] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([user_id], [user_type_id], [username], [password_hash], [firstname], [lastname], [email], [phone_number], [phone_number_country_code], [address], [license_id], [create_date], [modify_date], [dalete_date], [deleted_flag]) VALUES (1, 1, N'admin', N'd033e22ae348aeb5660fc2140aec35850c4da997f0ee0f0903382610593ee647', N'admin', N'admin', NULL, NULL, NULL, NULL, NULL, CAST(N'2024-07-31T00:00:00.000' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[users] ([user_id], [user_type_id], [username], [password_hash], [firstname], [lastname], [email], [phone_number], [phone_number_country_code], [address], [license_id], [create_date], [modify_date], [dalete_date], [deleted_flag]) VALUES (5, 2, N'cliente1', N'd033e22ae348aeb5660fc2140aec35850c4da997f0ee0f0903382610593ee647', N'Cliente', N'Prueba', N'email@email.com', N'1122334455', N'+54', NULL, NULL, CAST(N'2027-07-31T00:00:00.000' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[users] ([user_id], [user_type_id], [username], [password_hash], [firstname], [lastname], [email], [phone_number], [phone_number_country_code], [address], [license_id], [create_date], [modify_date], [dalete_date], [deleted_flag]) VALUES (6, 3, N'conductor1', N'd033e22ae348aeb5660fc2140aec35850c4da997f0ee0f0903382610593ee647', N'Conductor', N'Prueba', N'email@email.com', N'1122334455', N'+54', NULL, 1, CAST(N'2024-07-31T00:00:00.000' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[users] ([user_id], [user_type_id], [username], [password_hash], [firstname], [lastname], [email], [phone_number], [phone_number_country_code], [address], [license_id], [create_date], [modify_date], [dalete_date], [deleted_flag]) VALUES (7, 3, N'conductor2', N'd033e22ae348aeb5660fc2140aec35850c4da997f0ee0f0903382610593ee647', N'Conductor 2', N'Prueba', N'email@email.com', N'1122334455', N'+54', NULL, 1, CAST(N'2024-07-31T00:00:00.000' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[users] ([user_id], [user_type_id], [username], [password_hash], [firstname], [lastname], [email], [phone_number], [phone_number_country_code], [address], [license_id], [create_date], [modify_date], [dalete_date], [deleted_flag]) VALUES (8, 3, N'conductor3', N'd033e22ae348aeb5660fc2140aec35850c4da997f0ee0f0903382610593ee647', N'Conductor 3', N'Prueba', N'email@email.com', N'123-456-7890', N'+1', N'456 Another St, City, Country', NULL, CAST(N'2024-07-31T01:40:02.227' AS DateTime), NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[users] OFF
GO
ALTER TABLE [dbo].[licenses] ADD  CONSTRAINT [DF_licenses_deleted_flag]  DEFAULT ((0)) FOR [deleted_flag]
GO
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_deleted_flag]  DEFAULT ((0)) FOR [deleted_flag]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_users] FOREIGN KEY([request_user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_users]
GO
ALTER TABLE [dbo].[rides]  WITH CHECK ADD  CONSTRAINT [FK_rides_orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([order_id])
GO
ALTER TABLE [dbo].[rides] CHECK CONSTRAINT [FK_rides_orders]
GO
ALTER TABLE [dbo].[rides]  WITH CHECK ADD  CONSTRAINT [FK_rides_ride_status] FOREIGN KEY([status_id])
REFERENCES [dbo].[ride_status] ([ride_status_id])
GO
ALTER TABLE [dbo].[rides] CHECK CONSTRAINT [FK_rides_ride_status]
GO
ALTER TABLE [dbo].[rides]  WITH CHECK ADD  CONSTRAINT [FK_rides_user_driver] FOREIGN KEY([user_driver_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[rides] CHECK CONSTRAINT [FK_rides_user_driver]
GO
ALTER TABLE [dbo].[user_type_roles]  WITH CHECK ADD  CONSTRAINT [FK_user_type_roles_permission_roles] FOREIGN KEY([permission_role_id])
REFERENCES [dbo].[permission_roles] ([permission_role_id])
GO
ALTER TABLE [dbo].[user_type_roles] CHECK CONSTRAINT [FK_user_type_roles_permission_roles]
GO
ALTER TABLE [dbo].[user_type_roles]  WITH CHECK ADD  CONSTRAINT [FK_user_type_roles_user_types] FOREIGN KEY([user_type_id])
REFERENCES [dbo].[user_types] ([user_type_id])
GO
ALTER TABLE [dbo].[user_type_roles] CHECK CONSTRAINT [FK_user_type_roles_user_types]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_licenses] FOREIGN KEY([license_id])
REFERENCES [dbo].[licenses] ([license_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_licenses]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_user_types] FOREIGN KEY([user_type_id])
REFERENCES [dbo].[user_types] ([user_type_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_user_types]
GO
/****** Object:  StoredProcedure [dbo].[sp_CrearUsuarioConductor]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CrearUsuarioConductor]
    @username                    VARCHAR(100),
    @password_hash               VARCHAR(500),
    @firstname                   VARCHAR(200) = NULL,
    @lastname                    VARCHAR(200) = NULL,
    @email                       VARCHAR(200) = NULL,
    @phone_number                VARCHAR(100) = NULL,
    @phone_number_country_code   VARCHAR(10) = NULL,
    @address                     VARCHAR(200) = NULL
AS
BEGIN
    -- Insert a new record into the users table
    INSERT INTO [dbo].[users]
           ([user_type_id]
           ,[username]
           ,[password_hash]
           ,[firstname]
           ,[lastname]
           ,[email]
           ,[phone_number]
           ,[phone_number_country_code]
           ,[address]
           ,[license_id]
           ,[create_date]
           ,[modify_date]
           ,[deleted_flag])
    VALUES
           (3   -- Usuario tipo conductor
           ,@username
           ,@password_hash
           ,@firstname
           ,@lastname
           ,@email
           ,@phone_number
           ,@phone_number_country_code
           ,@address
           ,NULL
           ,GETDATE()   -- Current system date and time
           ,NULL
           ,0);         -- Default value for deleted_flag

    -- Optionally, you can add error handling or additional logic here
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllConductoresConPaginacion]    Script Date: 31/7/2024 01:49:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAllConductoresConPaginacion]
    @PageNumber INT,
    @RowsPerPage INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        user_id, 
        user_types.user_type_id, 
        user_types.user_type_name, 
        username, 
        password_hash, 
        firstname, 
        lastname, 
        email, 
        phone_number, 
        phone_number_country_code, 
        address, 
        license_id, 
        create_date, 
        modify_date, 
        dalete_date, 
        deleted_flag
    FROM 
        users
    JOIN 
        user_types ON users.user_type_id = user_types.user_type_id
    WHERE 
        user_types.user_type_id = 3
    ORDER BY 
        user_id
    OFFSET 
        (@PageNumber - 1) * @RowsPerPage ROWS
    FETCH NEXT 
        @RowsPerPage ROWS ONLY;
END
GO

