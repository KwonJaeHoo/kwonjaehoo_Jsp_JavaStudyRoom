package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;

import com.sist.web.model.Board;
import com.sist.web.model.Like;

public class LikeDao 
{
	private static Logger logger = LogManager.getLogger(BoardDao.class);
	
	public long boardLikeInsert(Like like)
	{
		long count = 0;
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO ");
		sql.append("       BOARD_LIKE_DATA (BD_SEQ, UD_ID) ");
		sql.append("       VALUES(?, ?) ");
		
		try
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			Like likeSelect = boardLikeSelect(connection, like);
			
			if(likeSelect == null)
			{
				preparedStatement = connection.prepareStatement(sql.toString());
				preparedStatement.setLong(++cnt, like.getBdSeq());
				preparedStatement.setString(++cnt, like.getUdId());
				
				count = preparedStatement.executeUpdate();
			}
		}
		catch(Exception e)
		{
			logger.error("[LikeDao] boardLikeInsert, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(preparedStatement, connection);
		}
		return count;
	}
	
	public Like boardLikeSelect(Connection connection, Like like)
	{
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT BD_SEQ, UD_ID ");
		sql.append("  FROM BOARD_LIKE_DATA ");
		sql.append(" WHERE BD_SEQ = ? ");
		sql.append("   AND UD_ID = ? ");
		
		Like likeSelect = null;
		
		try
		{
			int cnt = 0;
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setLong(++cnt, like.getBdSeq());
			preparedStatement.setString(++cnt, like.getUdId());
			
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
			{
				likeSelect = new Like();
				likeSelect.setBdSeq(resultSet.getLong("BD_SEQ"));
				likeSelect.setUdId(resultSet.getString("UD_ID"));
			}
		}
		catch(Exception e)
		{
			logger.error("[LikeDao] boardLikeSelect, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement);
		}
		
		return likeSelect;
	}
	
	public Board boardLikeCountSelect(Connection connection, long bdSeq) 
	{	
		Board board = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT BD.BD_SEQ,(SELECT COUNT(BLD.BD_SEQ) ");
		sql.append("			        FROM BOARD_LIKE_DATA BLD ");
		sql.append("			       WHERE BLD.BD_SEQ = BD.BD_SEQ) BD_LIKE_CNT ");
		sql.append("  FROM BOARD_DATA BD ");
		sql.append(" WHERE BD.BD_SEQ = ? ");

		try
		{
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setLong(1, bdSeq);
			
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
			{
				board = new Board();
				
				board.setBdSeq(resultSet.getLong("BD_SEQ"));
				board.setBdLikeCnt(resultSet.getLong("BD_LIKE_CNT"));
			}
			
		}
		catch(Exception e) 
		{
			logger.error("[LikeDao] boardLikeCountSelect, SQL Exception", e);
		}
		finally
		{
			DBManager.close(resultSet, preparedStatement);
		}
		
		return board;
	}
	
	public long boardLikeDelete(Connection connection, long bdSeq)
	{
		long count = 0;
		
		PreparedStatement preparedStatement = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("DELETE FROM BOARD_LIKE_DATA WHERE BD_SEQ = ? ");
		
		try
		{
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setLong(1, bdSeq);
			
			count = preparedStatement.executeUpdate();
		}
		catch(Exception e) 
		{
			logger.error("[LikeDao] boardLikeDelete, SQL Exception", e);
		}
		finally
		{
			DBManager.close(preparedStatement);
		}
		
		return count;
	}


}
