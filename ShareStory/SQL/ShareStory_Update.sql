USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[ShareStory_Update]    Script Date: 12/26/2022 14:25:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Joe Medina
-- Create date: 10/27/2022
-- Description:	Update for dbo.ShareStory (only SysAdmin & CreatedBy User)
-- Code Reviewer:


-- MODIFIED BY: author
-- MODIFIED DATE: 10/27/2022
-- Code Reviewer: 
-- Note: 
-- =============================================
ALTER proc [dbo].[ShareStory_Update]
	@batchIds dbo.IdTable READONLY
	,@Id int
	,@Name nvarchar(50)
	,@Email nvarchar(50)
	,@Story nvarchar(3000)
	,@UserId int

AS
/*

DECLARE	@newIds dbo.IdTable
INSERT INTO	@newIds
	(Id)
VALUES
	(12)
	,(13)

DECLARE	@Id int = 25
		,@Name nvarchar(50) = 'Shaq'
		,@Email nvarchar(50) = 'shaq@test.com'
		,@Story nvarchar(3000) = 'story of Shaq'
		,@UserId int = 44

EXECUTE	dbo.ShareStory_Update
	@newIds
	,@Id
	,@Name
	,@Email
	,@Story
	,@UserId



SELECT *
FROM	dbo.ShareStory

*/

BEGIN

	UPDATE	[dbo].[ShareStory]
	SET		[Name] = @Name
			,[Email] = @Email
			,[Story] = @Story
			,ModifiedBy = @UserId
			,DateModified = GETUTCDATE()
	WHERE	Id = @Id
			AND (CreatedBy = @UserId
				OR @UserId = 
					(
					SELECT	u.Id
					FROM	dbo.Users as u
							INNER JOIN dbo.UserRoles as ur
								ON u.Id = ur.UserId
								AND ur.RoleId = 3
					WHERE	u.Id = @UserId
					)
				)

	IF @UserId =
			(
			SELECT	u.Id
			FROM	dbo.Users as u
					INNER JOIN dbo.UserRoles as ur
						ON u.Id = ur.UserId
						AND ur.RoleId = 3
			WHERE	u.Id = @UserId
			)
		AND @Id =
			(
			SELECT	s.Id
			FROM	dbo.ShareStory as s
			WHERE	s.Id = @Id
			)
		BEGIN
			DELETE
			FROM	dbo.ShareStoryFile
			WHERE	storyId = @Id

			INSERT INTO dbo.ShareStoryFile
				(fileId
				,storyId)
			SELECT	i.Id
					,@Id
			FROM	@batchIds as i
		END
	ELSE
		IF @UserId =
				(
				SELECT	s.CreatedBy
				FROM	dbo.ShareStory AS s
				WHERE	s.Id = @Id
				)
			AND @Id =
				(
				SELECT	s.Id
				FROM	dbo.ShareStory as s
				WHERE	s.Id = @Id
				)
			BEGIN
				DELETE
				FROM	dbo.ShareStoryFile
				WHERE	storyId = 
							(
							SELECT	s.Id
							FROM	dbo.ShareStory as s
							WHERE	(s.CreatedBy = @UserId
									AND s.Id = @Id)
							)
				INSERT INTO dbo.ShareStoryFile
					(fileId
					,storyId)
				SELECT	i.Id
						,@Id
				FROM	@batchIds as i
			END
END
