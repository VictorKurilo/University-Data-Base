
use master
-- creting database --
create database UniversityDB
on
(
	name = 'UniversityDB',
	filename = 'C:\University.mdf', -- path were we store our database
	size = 10MB,
	maxsize = 100MB,
	filegrowth = 10MB
)
log on
(
	name = 'UniversityDBLog',
	filename = 'C:\University.ldf', -- path were we store our log database
	size = 5MB,
	maxsize = 50MB,
	filegrowth = 5MB
)
go



-- creating tables --
create table Students
(
	id int not null identity,
	FirstName nvarchar(30) null,
	MiddleName nvarchar(30) null,
	LastName nvarchar(30) null,
	Email nvarchar(50) null
)
create table Students_Info
(
	id int not null,
	Job_ID int null,
	Adress_ID int null,
	Phone char(9) null,
	Sex nvarchar(20),
	BirthDate date not null
)

create table Job
(
	id int not null identity,
	[Name] nvarchar(30) null
)

create table Job_Info
(
	id int not null,
	Adress_ID int null,
	Phone char(9) null,
	[Start_Date] date null,
	[Finish_Date] date null,
	Salary money null
)

create table Universitys
(
	id int not null identity,
	[Name] nvarchar(50),
	Email nvarchar(50)
)

create table Universitys_Info
(
	id int not null,
	[Description] nvarchar(max) null,
	Adress_ID int null,
	Phone char(9) null
)

create table Adress
(
	id int not null identity,
	[Adress] nvarchar(30),
	City nvarchar(30),
	Province nvarchar(30),
	Postal_Code nvarchar(20)
)


create table Education 
(
	id int not null identity,
	Student_ID int null,
	University_ID int null
)

create table Education_Info
(
	Education_ID int not null,
	Program_ID int not null,
	Start_Year date null,
	Finish_Year date null,
	Total_Price money not null
)

create table Program
(
	id int not null identity,
	Program_Level_ID int null,
	[Name] nvarchar(40) null
)


create table Program_Level
(
	id int not null identity,
	[Name] nvarchar(40) null
)

create table Categories
(
	id int not null identity,
	Skills_ID int null,
	Subjects_ID int null,
	Program_ID int null	
)


create table Skills
(
	id int not null identity,
	[Name] nvarchar(20) null
)

create table [Subjects]
(
	id int not null identity,
	[Name] nvarchar(50) null
)


--- creating relation between tables --
alter table Adress
add constraint PK_Adress
primary key(ID)

alter table Students
add constraint PK_Students 
primary key (ID)

alter table Students_Info
add constraint UQ_Students_Info
unique (ID)

alter table Students_Info
add constraint FK_Students_Info_Students 
foreign key (ID) references Students(ID)
on delete cascade 

alter table Students_Info
add constraint FK_Students_Info_Adress 
foreign key (Adress_ID) references Adress(ID)
on delete cascade 

alter table Job
add constraint PK_Job
primary key (ID)

alter table Job_Info
add constraint UQ_Job_Info
unique (ID)

alter table Job_Info
add constraint FK_Job_Job_Info
foreign key (ID) references Job(ID)
on delete cascade

alter table Job_Info
add constraint FK_Job_Info_Adress
foreign key (Adress_ID) references Adress(ID)
on delete cascade

alter table Universitys
add constraint PK_Universitys
primary key (ID)

alter table Universitys_Info
add constraint UQ_Universitys_Info
unique (ID)

alter table Universitys_Info
add constraint FK_Universitys_Info_Universitys
foreign key (ID) references Universitys(ID)

alter table Universitys_Info
add constraint FK_Universitys_Info_Adress
foreign key (Adress_ID) references Adress(ID)
on delete cascade

alter table Education
add constraint PK_Education
primary key (ID)

alter table Education
add constraint FK_Education_Students
foreign key(Student_ID) references Students(ID) 
on delete set null

alter table Education
add constraint FK_Education_Universitys
foreign key (University_ID) references Universitys(ID)

alter table Education_Info
add constraint PK_Education_Info_Education_Program
primary key(Education_ID, Program_ID)

alter table Education_Info
add constraint FK_Education_Info_Education
foreign key(Education_ID) references Education(ID)

alter table Program
add constraint PK_Program
primary key (ID)

alter table Education_Info
add constraint FK_Education_Info_Program
foreign key(Program_ID) references Program(ID)

alter table Program_Level
add constraint PK_Program_Level
primary key (ID)

alter table Program
add constraint FK_Program_Program_Level
foreign key (Program_Level_ID) references Program_Level(ID)
on delete set null

alter table Skills
add constraint PK_Skills
primary key(ID)

alter table Subjects
add constraint PK_Subjects
primary key (ID)

alter table Categories
add constraint PK_Categories
primary key (ID)

alter table Categories
add constraint FK_Categories_Skills
foreign key(Skills_ID) references Skills(ID)
on delete set null

alter table Categories
add constraint FK_Categories_Subjects
foreign key (Subjects_ID) references Subjects(ID)
on delete set null

alter table Categories
add constraint FK_Categories_Program
foreign key (Program_ID) references Program (ID)
on delete set null

-- limitations --

alter table Students_Info
add constraint Students_Info_Phone
check (phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

alter table Students_info
add check (sex in('male', 'female'))

 -- only studetns with ages between 18-50 can join university
alter table Students_Info
add check (BirthDate between dateadd(year, -50, getdate()) and dateadd(year, -18, getdate()))

alter table Job_info
add constraint Job_info_Phone
check (phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

-- to show that some students started 2 years ago
alter table Job_info
add check ([Start_Date] >= dateadd(year, -2, getdate()))

alter table Job_info
add check ([Finish_Date] >= dateadd(year, -1, getdate()) and Finish_Date >= getdate())

alter table Job_info
add check (salary >= 0)

alter table Universitys_Info
add constraint Universitys_info_Phone
check (phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

alter table Education_Info
add check (Start_Year >= dateadd(year, -4, getdate()))

alter table Education_Info
add check (Finish_Year >= dateadd(year, -1, getdate()) and Finish_Year >= getdate())

alter table Education_Info
add check (Total_Price >= 0)

alter table Program_level
add check ([name] in ('beginner', 'intermediate', 'professional', 'expert'))


-- inserting into tables --

insert into Adress([Adress], City, Postal_Code)
values

('Руденко 21а, 137','Тернополь','0635'),
('Бажова 77','Киев','0933'),
('Бажана 6, 22','Москва','6867'),
('Мышуги 25','Львов','9111'),
('Дружнова 15','Минск','9325'),
('Ковпака 24, 17','Киев','1311'),
('Лесная 21','Тернополь','2144'),
('Дорожная 77, 99','Москва','1255'),
('Контрактна 20','Николаев','1533'),
('Медовая 1','Минск','9380'),
('Артема 23','Львов','5558'),
('Миская 2, 17','Минск','9635'),
('Восточная 7','Киев','1133'),
('Курская 6, 22','Москва','10067'),
('Древнея 115','Смоленск','2111'),
('Сружная 13','Минск','3125'),
('Main Street 13','New York','3125'),
('Машерова 1','Минск','1250'),
('Снежнпя 3','Минск','1233'),
('Столичная 77','Москва','10205')

insert into Job ([Name])
values
('Программист'),
('Продавец'),
('Овициант'),
('Тренер')


insert into Job_info(id, Adress_ID, Phone, [Start_Date], [Finish_Date], Salary)
values
(1, 13, '95223428',  dateadd(year, -1, GETDATE()), dateadd(MONTH, 6, GETDATE()), 500),
(2, 14, '95242375', dateadd(year, -1, GETDATE()), dateadd(MONTH, 1, GETDATE()), 300),
(3, 15, '95235455', dateadd(MONTH, -6, GETDATE()), null, 400),
(4, 16, '95624722', dateadd(year, -1, GETDATE()), dateadd(MONTH, 10, GETDATE()), 300)

insert into Students(FirstName, MiddleName, LastName, Email)
values
('Виктор','Викторович','Прокопенко','propenko@gmail.com'),
('Антон','Олегович','Крук','kruk@hotmail.com'),
('Оксана','Владимировна','Десятова','desyatkova@mail.ru'),
('Антонина','Дмитриевна','Шевченко','shevchenko@gmail.com'),
('Анатолий','Петрович','Дмитров','dmitrov15@gmail.com'), 
('Иван','Иванович','Кобзар','kobzak.invan@mail.ru'), 
('Виктор','Олегович','Грачь','victor.oleg@gmail.com'), 
('Ольга','Алексеевна','Буткова','butova@hotmail.com'), 
('Алина','Михайловна','Мелова','melova.alina@yahoo.com'), 
('Михаил','Андреевич','Савицкий','mikhail.andreay@gmail.com'),
('Артем','Иванович','Крава','artem200@mail.ru') 


insert into Students_Info(id, Adress_ID, Job_ID, Phone, Sex, BirthDate)
values
(1, 1, 1, '95223433', 'male', '08/15/1985'),
(2, 2, null, '95123433', 'male', '07/15/1987'),
(3, 3, 2, '61023466', 'female', '12/19/1992'),
(4, 4, 2, '95223434', 'female', '07/14/1988'),
(5, 5, null, '60210419', 'male', '02/01/1996'),
(6, 6, null, '95245112', 'male', '03/11/1995'),
(7, 7, 4, '95089444', 'male', '08/13/1989'),
(8, 8, 2, '95856433', 'female', '09/22/1995'),
(9, 9, null, '61023433', 'female', '01/05/2000'),
(10, 10, null, '95233443', 'male', '11/11/1997'),
(11, 11, 3, '95233465', 'male', '06/25/1993')


insert into Universitys ([name], Email)
values
('Amridge University', 'amridge@university.com'),
('Fairmon State University', 'fair.uni@university.com'),
('GateWay University', 'gateway@uni.com'),
('School of Economics', 'school.uni@schoo.com')

insert into Universitys_Info(id, [Description], Adress_ID, Phone)
values
(1, 'Amridge University of Science and Art', 17, '45455229'),
(2, 'State Teachers University of Religion', 18, '95013020'),
(3, 'Technology and Computer Science', 19, '95283828'),
(4, 'Advanced School of Ecnomics', 20, '65233433')

insert into Program_Level ([Name])
values 
('beginner'),
('intermediate'),
('professional'),
('expert')

insert into Program (Program_Level_ID, [Name])
values
(1, 'Computer science'),
(1, 'Graphics design'),
(2, 'Web development'),
(1, 'Interpreneurship'),
(3, 'Bussiness and Administration'),
(1, 'Economics'),
(4, 'Hotel Manager'),
(3, 'Economics and Science'),
(1, 'Tourism'),
(4, 'Advanced computer engeneering'),
(3, 'Rocket Science'),
(1, 'Computer Administrator')


insert into Education (Student_ID, University_ID)
values
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 3),
(6, 1),
(7, 4),
(8, 1),
(9, 4),
(10, 2),
(11, 3)

insert into Education_Info (Education_ID, Program_ID, Start_Year, Finish_Year, Total_Price)
values
(1, 4, dateadd(YEAR, -2, GETDATE()), dateadd(YEAR, 3, GETDATE()), 6000),
(2, 6, dateadd(YEAR, -3, GETDATE()), dateadd(YEAR, 2, GETDATE()), 3000),
(3, 9, dateadd(YEAR, -3, GETDATE()), dateadd(YEAR, 1, GETDATE()), 4000),
(4, 3, dateadd(YEAR, -3, GETDATE()), dateadd(YEAR, 2, GETDATE()), 8000),
(5, 1, dateadd(YEAR, -1, GETDATE()), dateadd(YEAR, 5, GETDATE()), 7000),
(6, 6, dateadd(YEAR, -1, GETDATE()), dateadd(YEAR, 4, GETDATE()), 8000),
(7, 5, dateadd(YEAR, -2, GETDATE()), dateadd(YEAR, 2, GETDATE()), 5000),
(8, 6, dateadd(YEAR, -2, GETDATE()), dateadd(YEAR, 3, GETDATE()), 13000),
(9, 7, dateadd(YEAR, -3, GETDATE()), dateadd(YEAR, 2, GETDATE()), 11000),
(10, 9, dateadd(YEAR, -3, GETDATE()), dateadd(YEAR, 1, GETDATE()), 16000),
(11, 10, dateadd(YEAR, -3, GETDATE()), dateadd(YEAR, 3, GETDATE()), 15000)


insert into Categories (Skills_ID, Subjects_ID, Program_ID)
values
(16,1,1),     
(17,1,1),
(18,1,1),
(16,2,1),
(17,2,1),
(18,2,1),			
(1,4,2),
(2,4,2),
(3,4,2),				
(1,6,3),
(2,6,3),
(3,6,3),
(11,6,3),
(1,4,3),
(2,4,3),
(3,4,3),
(11,4,3),
(1,7,3),
(2,7,3),
(3,7,3),
(11,7,3),
(14,7,3),
(11,8,3),
(14,8,3),
(1,8,3),
(2,8,3),
(3,8,3),            
(4,10,4),
(9,10,4),
(6,10,4),
(10,10,4),
(9,12,4),
(13,12,4),
(4,12,4),
(6,12,4),
(13,11,4),
(4, 11,4),				
(6,11,4),
(4,11,5),
(6,12,5),				
(13,11,6),			
(7,13,7),
(8,12,7),	
(9,13,7),
(7,12,7),		
(8,13,7),
(9,12,7),					
(4,13,8),
(6,13,8),
(13,13,8),
(9,10,8),		
(4,10,8),
(6,10,8),
(13,10,8),
(9,10,8),	
(4,10,8),
(6,12,8),
(13,12,8),
(9,12,8),			
(7,12,9),
(8,12,9),
(4,12,9),
(8,16,9),
(9,16,9),
(8,16,9),
(7,16,9),					
(4,9,10),
(5,9,10),
(6,9,10),
(13,10,10),
(4,15,10),
(5,15,10),
(6,15,10),
(13,15,10),
(4,14,10),
(5,14,10),
(6,14,10),
(13,14,10),	
(4,9,11),
(5,10,11),
(6,14,11),
(13,15,11),				
(4,9,12),
(5,9,12),
(5,10,12),
(6,10,12)				
			

insert into Skills ([Name])
values 
('design'),
('creative'),
('drawing'),
('professional'),
('algebra'),
('geometry'),
('spanish'),
('russian'),
('english'),
('german'),
('photoshop'),
('visual studio'),
('calculus'),
('web development'),
('JavaScript'),
('java'),
('c++'),
('c#')

insert into [Subjects] ([Name])
values
('intro computer science'),
('beginner course to programming'),
('intermediate programming'),
('web development from zero to gero'),
('basics of web design'),
('how to draw for web design'),
('photoshop for designers'),
('modern graphics development'),
('introduction into math'),
('advanced economics and calculations'),
('business administration'),
('staff management'),
('orgaznication and prioritization'),
('advacned engeneering'),
('expert math and graphs'),
('culture and languages')



			-- printing students associated with universitys --
select s.FirstName + s.LastName as [Full Name], p.[Name] as Program, pl.[Name] as Dificulty,
 u.[Name] as University, ei.Start_Year, ei.Finish_Year, ei.Total_Price from education e
	join Students s
		on e.Student_ID = s.id
	join Universitys u
		on e.University_ID = u.id
	join Education_Info ei
		on e.id = ei.Education_ID
	join Program p
		on ei.Program_ID = p.id
	join Program_Level pl
		on p.Program_Level_ID = pl.id
		


		 -- printing info on students --
select s.FirstName + s.LastName as FullName, a.Adress, a.City, si.Sex,
si.BirthDate, si.Phone, j.[Name] as Position, ji.Salary, ji.[Start_Date],
ji.[Finish_Date] from Students s
	left join Students_Info si
		on s.id = si.id
		 join Adress a
		on si.Adress_ID = a.id
	left join Job j
		on si.Job_ID = j.id
	left join Job_Info ji
		on j.id = ji.id
			

			-- prints that each students doint one program can do many subjects --
select s.FirstName + s.LastName as FullName, p.[Name] as Program, su.[Name] as Subjects from Education e
	join Students s
		on e.Student_ID = s.id
	join Education_Info ei
		on ei.Education_ID = e.id
	join Program p
		on ei.Program_ID = p.id
	join Categories c
		on p.id = c.Program_ID
	join Subjects su
		on c.Subjects_ID = su.id
		group by s.FirstName + s.LastName,  p.[Name], su.[Name]


		-- program can have many different subjects --
select p.[Name] as Program, su.[Name] as [Subject] from Program p
	join Categories c
		on p.id = c.Program_ID  -- and c.Program_ID = 4  -- to show custom result of Program having many Subjects
	join Skills sk
		on c.Skills_ID = sk.id
	join Subjects su
		on c.Subjects_ID = su.id
		group by  p.[Name], su.[Name]



		-- each subject can have many different skills
select su.[Name] as [Subject], sk.[Name] as Skills from Program p
	join Categories c
		on p.id = c.Program_ID  
	join Skills sk
		on c.Skills_ID = sk.id
	join Subjects su
		on c.Subjects_ID = su.id
		group by  su.[Name], sk.[Name]