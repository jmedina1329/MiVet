USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[ShareStory_Delete]    Script Date: 12/26/2022 14:25:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Joe Medina
-- Create date: 10/27/2022
-- Description:	Delete for dbo.ShareStory (only SysAdmin & CreatedBy User)
-- Code Reviewer:


-- MODIFIED BY: author
-- MODIFIED DATE: 10/27/2022
-- Code Reviewer: 
-- Note: 
-- =============================================
ALTER proc [dbo].[ShareStory_Delete]
	@Id int
	,@UserId int

AS

/*

DECLARE @Id int = 24
		,@UserId int = 74

EXECUTE dbo.ShareStory_Delete
	@Id
	,@UserId

*/

BEGIN

	IF EXISTS
			(
			SELECT	u.Id
			FROM	dbo.Users as u
					INNER JOIN dbo.UserRoles as ur
						ON u.Id = ur.UserId
						AND ur.RoleId = 3
			WHERE	u.Id = @UserId
			)
		DELETE
		FROM	dbo.ShareStoryFile
		WHERE	storyId = @Id
	ELSE
		DELETE
		FROM	dbo.ShareStoryFile
		WHERE	storyId = 
					(
					SELECT	s.Id
					FROM	dbo.ShareStory as s
					WHERE	(s.CreatedBy = @UserId
							AND s.Id = @Id)
					)

	DELETE
	FROM	dbo.ShareStory
	WHERE	Id = @Id 
			AND (CreatedBy = @UserId
				OR @UserId =
					(
					SELECT	u.Id
					FROM	dbo.Users as u
							INNER JOIN dbo.UserRoles as ur
								ON u.Id = ur.UserId
								AND ur.RoleId = 3
					WHERE	Id = @UserId
					)
				)

END
