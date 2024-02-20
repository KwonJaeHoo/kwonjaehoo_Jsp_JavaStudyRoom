package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.common.util.StringUtil;
import com.sist.web.db.DBManager;

import java.util.ArrayList;
import java.util.List;
import com.sist.web.model.Board;

public class BoardDao
{
	private static Logger logger = LogManager.getLogger(BoardDao.class);
	LikeDao likeDao = new LikeDao();
	
	public long boardCountSelect(Board boardSearch)
	{
		long count = 0;
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		StringBuilder sql = new StringBuilder();
 
		sql.append("SELECT COUNT(BD.BD_SEQ) BOARD_COUNT ");
		sql.append("  FROM BOARD_DATA BD, USER_DATA UD ");
		sql.append(" WHERE BD.UD_ID = UD.UD_ID ");
		
		if(boardSearch != null)
		{
			if(!StringUtil.isEmpty(boardSearch.getBdTitle()))
			{
				sql.append("   AND BD.BD_TITLE LIKE '%' || ? || '%' ");
			}
			if(!StringUtil.isEmpty(boardSearch.getUdNickname()))
			{
				sql.append("   AND UD.UD_NICKNAME LIKE '%' || ? || '%' ");
			}
			if(!StringUtil.isEmpty(boardSearch.getBdContent()))
			{
				sql.append("   AND DBMS_LOB.INSTR(BD.BD_CONTENT, ?) > 0 ");
			}
			if(!StringUtil.isEmpty(boardSearch.getUdId()))
			{
				sql.append("   AND UD.UD_ID = ? ");
			}
		}

		try 
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			
			if(boardSearch != null)
			{
				if(!StringUtil.isEmpty(boardSearch.getBdTitle()))
				{
					preparedStatement.setString(++cnt, boardSearch.getBdTitle());
				}
				if(!StringUtil.isEmpty(boardSearch.getUdNickname()))
				{
					preparedStatement.setString(++cnt, boardSearch.getUdNickname());
				}
				if(!StringUtil.isEmpty(boardSearch.getBdContent()))
				{
					preparedStatement.setString(++cnt, boardSearch.getBdContent());
				}
				if(!StringUtil.isEmpty(boardSearch.getUdId()))
				{
					preparedStatement.setString(++cnt, boardSearch.getUdId());
				}
			}
			
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
			{
				count = resultSet.getLong("BOARD_COUNT");
			}
		} 
		catch (Exception e) 
		{
			logger.error("[BoardDao] boardCountSelect, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement, connection);
		}
		return count;
	}
	
	public List<Board> boardListSelect(Board boardSearch)
	{
		List<Board> list = new ArrayList<Board>();
	
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT BD_SEQ, ");
		sql.append("       BD_TITLE, ");
		sql.append("       BD_CONTENT, ");
		sql.append("       UD_ID, ");
		sql.append("       UD_NICKNAME, ");
		sql.append("	   BD_READ_CNT, ");
		sql.append("       BD_REG_DATE, ");
		sql.append("       BD_MOD_DATE, ");
		sql.append("       BD_SECRET, ");
		sql.append("       BD_LIKE_CNT ");
		sql.append("  FROM (SELECT ROWNUM RNUM, ");
		sql.append("       		   BD_SEQ, ");
		sql.append("               BD_TITLE, ");
		sql.append("               BD_CONTENT, ");
		sql.append("               UD_ID, ");
		sql.append("               UD_NICKNAME, ");
		sql.append("               BD_READ_CNT, ");
		sql.append("               BD_REG_DATE, ");
		sql.append("               BD_MOD_DATE, ");
		sql.append("               BD_SECRET, ");
		sql.append("               BD_LIKE_CNT ");
		sql.append("          FROM (SELECT BD.BD_SEQ, ");
		sql.append("                       BD.BD_TITLE,");
		sql.append("                       BD.BD_CONTENT, ");
		sql.append("                       UD.UD_ID, ");
		sql.append("                       UD.UD_NICKNAME, ");
		sql.append("                       BD.BD_READ_CNT, ");
		sql.append("                       TO_CHAR(BD.BD_REG_DATE, 'YYYY.MM.DD HH24:MI:SS') BD_REG_DATE, ");
		sql.append("                       TO_CHAR (BD.BD_MOD_DATE, 'YYYY.MM.DD HH24:MI:SS') BD_MOD_DATE, ");
		sql.append("                       BD.BD_SECRET, ");
		sql.append("                       (SELECT COUNT(BD_SEQ) FROM BOARD_LIKE_DATA WHERE BD_SEQ = BD.BD_SEQ) BD_LIKE_CNT ");
		sql.append("                  FROM BOARD_DATA BD, USER_DATA UD ");
		sql.append("                 WHERE BD.UD_ID = UD.UD_ID ");
			
		if(boardSearch != null)
		{
			if(!StringUtil.isEmpty(boardSearch.getBdTitle()))
			{
				sql.append("                   AND BD.BD_TITLE LIKE '%' || ? || '%' ");
			}
			if(!StringUtil.isEmpty(boardSearch.getUdNickname()))
			{
				sql.append("                   AND UD.UD_NICKNAME LIKE '%' || ? || '%' ");
			}
			if(!StringUtil.isEmpty(boardSearch.getBdContent()))
			{
				sql.append("                   AND DBMS_LOB.INSTR(BD.BD_CONTENT, ?) > 0 ");
			}
			if(!StringUtil.isEmpty(boardSearch.getUdId()))
			{
				sql.append("                   AND UD.UD_ID = ? ");
			}
		}
		
		if(StringUtil.equals("1", boardSearch.getBdSort()))
		{
			sql.append("                 ORDER BY BD.BD_SEQ DESC)) ");
		}
		else if(StringUtil.equals("2", boardSearch.getBdSort()))
		{
			sql.append("                 ORDER BY BD_LIKE_CNT DESC)) ");
		}
		else if(StringUtil.equals("3", boardSearch.getBdSort()))
		{
			sql.append("                 ORDER BY BD.BD_READ_CNT DESC)) ");
		}	

		
		if(boardSearch != null && boardSearch.getStartRow() != 0 && boardSearch.getEndRow() != 0)
		{
			sql.append(" WHERE RNUM >= ? ");
			sql.append("   AND RNUM <= ? ");
		}
		
		try
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			
			if(boardSearch != null)
			{
				if(!StringUtil.isEmpty(boardSearch.getBdTitle()))
				{
					preparedStatement.setString(++cnt, boardSearch.getBdTitle());
				}
				if(!StringUtil.isEmpty(boardSearch.getUdNickname()))
				{
					preparedStatement.setString(++cnt, boardSearch.getUdNickname());
				}
				if(!StringUtil.isEmpty(boardSearch.getBdContent()))
				{
					preparedStatement.setString(++cnt, boardSearch.getBdContent());
				}
				if(!StringUtil.isEmpty(boardSearch.getUdId()))
				{
					preparedStatement.setString(++cnt, boardSearch.getUdId());
				}
			
				if(boardSearch.getStartRow() != 0 && boardSearch.getEndRow() != 0)
				{				
					preparedStatement.setLong(++cnt, boardSearch.getStartRow());
					preparedStatement.setLong(++cnt, boardSearch.getEndRow());
				}
			}

			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next())
			{
				Board board = new Board();
				
				board.setBdSeq(resultSet.getLong("BD_SEQ"));
				board.setBdTitle(resultSet.getString("BD_TITLE"));
				board.setBdContent(resultSet.getString("BD_CONTENT"));
				board.setUdId(resultSet.getString("UD_ID"));
				board.setUdNickname(resultSet.getString("UD_NICKNAME"));
				board.setBdReadCnt(resultSet.getLong("BD_READ_CNT"));
				board.setBdRegDate(resultSet.getString("BD_REG_DATE"));
				board.setBdModDate(resultSet.getString("BD_MOD_DATE"));
				board.setBdSecret(resultSet.getString("BD_SECRET"));
				board.setBdLikeCnt(resultSet.getLong("BD_LIKE_CNT"));
				
				list.add(board);
			}
		}
		catch (Exception e) 
		{
			logger.error("[BoardDao] boardListSelect, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement, connection);
		}
		return list;
	}
	
	//게시물 단건 조회
	public Board boardSelect(long bdSeq)
	{
		Board board = null;
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT BD.BD_SEQ, ");
		sql.append("	   BD.BD_TITLE, ");
		sql.append("	   BD.BD_CONTENT, ");
		sql.append("	   UD.UD_ID, ");
		sql.append("	   UD.UD_NICKNAME, ");
		sql.append("	   BD.BD_READ_CNT, ");
		sql.append("	   TO_CHAR(BD.BD_REG_DATE, 'YYYY.MM.DD HH24:MI:SS') BD_REG_DATE, ");
		sql.append("	   TO_CHAR (BD.BD_MOD_DATE, 'YYYY.MM.DD HH24:MI:SS') BD_MOD_DATE, ");
		sql.append("	   BD.BD_SECRET, ");
		sql.append("	   (SELECT COUNT(BD_SEQ) FROM BOARD_LIKE_DATA WHERE BD_SEQ = BD.BD_SEQ) BD_LIKE_CNT ");
		sql.append("  FROM BOARD_DATA BD, USER_DATA UD ");
		sql.append(" WHERE BD.UD_ID = UD.UD_ID ");
		sql.append("   AND BD.BD_SEQ = ? ");
		
		try
		{
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setLong(1, bdSeq);
			resultSet = preparedStatement.executeQuery();
		
			if(resultSet.next())
			{
				board = new Board();
				
				board.setBdSeq(resultSet.getLong("BD_SEQ"));
				board.setBdTitle(resultSet.getString("BD_TITLE"));
				board.setBdContent(resultSet.getString("BD_CONTENT"));
				board.setUdId(resultSet.getString("UD_ID"));
				board.setUdNickname(resultSet.getString("UD_NICKNAME"));
				board.setBdReadCnt(resultSet.getLong("BD_READ_CNT"));
				board.setBdRegDate(resultSet.getString("BD_REG_DATE"));
				board.setBdModDate(resultSet.getString("BD_MOD_DATE"));
				board.setBdSecret(resultSet.getString("BD_SECRET"));
				board.setBdLikeCnt(resultSet.getLong("BD_LIKE_CNT"));
			}
		}
		catch (Exception e) 
		{
			logger.error("[BoardDao] boardSelect, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement, connection);
		}
		return board;
	}
	//insert - BD.SEQ.NEXTVAL 을 즉시쓰는게 아니고 조회하고 쓰는거 그래서 METHOD 별도로 만들어서 호출 후 값 대입
	
	public long boardInsert(Board board)
	{
		long count = 0;
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO BOARD_DATA ");
		sql.append("(BD_SEQ, BD_TITLE, BD_CONTENT, UD_ID, UD_NICKNAME, BD_READ_CNT, BD_REG_DATE, BD_MOD_DATE, BD_SECRET, BD_LIKE_CNT) ");
		sql.append("       VALUES ");
		sql.append("(?, ?, ?, ?, ?, 0, SYSDATE, SYSDATE, ?, 0) ");

		try
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			board.setBdSeq(boardInsertSeq(connection));
			
			preparedStatement = connection.prepareStatement(sql.toString());
			
			preparedStatement.setLong(++cnt, board.getBdSeq());
			preparedStatement.setString(++cnt, board.getBdTitle());
			preparedStatement.setString(++cnt, board.getBdContent());
			preparedStatement.setString(++cnt, board.getUdId());
			preparedStatement.setString(++cnt, board.getUdNickname());
			preparedStatement.setString(++cnt, board.getBdSecret());

			count = preparedStatement.executeUpdate();
		}
		catch(Exception e) 
		{
			logger.error("[BoardDao] boardInsert, SQL Exception", e);
		}
		finally
		{
			DBManager.close(preparedStatement, connection);
		}		
		
		return count;
	}
	
	public long boardInsertSeq(Connection connection)
	{
		long count = 0;
		
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT BD_SEQ.NEXTVAL FROM DUAL ");
		
		try 
		{
			preparedStatement = connection.prepareStatement(sql.toString());
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
			{
				count = resultSet.getLong(1);
			}
		} 
		catch (Exception e) 
		{
			logger.error("[BoardDao] boardInsertSeq, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement);
		}

		return count;
	}
	
	public long boardUpdate(Board board)
	{
		long count = 0;
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE BOARD_DATA ");
		sql.append("   SET BD_TITLE = ?, ");
		sql.append("       BD_CONTENT = ?, ");
		sql.append("       BD_MOD_DATE = SYSDATE ");
		sql.append("       WHERE BD_SEQ = ? ");

		try
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			
			preparedStatement.setString(++cnt, board.getBdTitle());
			preparedStatement.setString(++cnt, board.getBdContent());
			preparedStatement.setLong(++cnt, board.getBdSeq());
			
			count = preparedStatement.executeUpdate();
		}
		catch (Exception e) 
		{
			logger.error("[BoardDao] boardUpdate, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(preparedStatement, connection);
		}
		return count;
	}
	
	
	public long boardDelete(long bdSeq)
	{
		long count = 0;
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("DELETE FROM BOARD_DATA WHERE BD_SEQ = ? ");
		
		try
		{
			connection = DBManager.getConnection();
			connection.setAutoCommit(false);
			Board board = likeDao.boardLikeCountSelect(connection, bdSeq);
			
			if(board != null)
			{
				//조회한 좋아요 값과 삭제된 좋아요 값이 같은가
				if(board.getBdLikeCnt() == likeDao.boardLikeDelete(connection, bdSeq))
				{
					preparedStatement = connection.prepareStatement(sql.toString());
					preparedStatement.setLong(1, bdSeq);
					count = preparedStatement.executeUpdate();
					connection.commit();
				}
				else
				{
					connection.rollback();
				}
			}
		}
		catch(Exception e) 
		{
			logger.error("[BoardDao] boardDelete, SQL Exception", e);
		}
		finally
		{
			DBManager.close(preparedStatement, connection);
		}
		
		return count;
	}
	
	public long boardReadCount(long bdSeq)
	{
		long count = 0;
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE BOARD_DATA ");
		sql.append("   SET BD_READ_CNT = BD_READ_CNT + 1 ");
		sql.append(" WHERE BD_SEQ = ? ");
		
		try
		{
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			
			preparedStatement.setLong(1, bdSeq); 	
			count = preparedStatement.executeUpdate();			
		}
		catch (Exception e) 
		{
			logger.error("[BoardDao] boardReadCount, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(preparedStatement, connection);
		}
		return count;
	}
	
	public long boardDeleteAll(List<Board> list)
	{
		long count = 0;
		
		try
		{
			for(int i = 0; i < list.size(); i++)
			{
				Board board = list.get(i);
				
				count += boardDelete(board.getBdSeq());
			}		
		}
		catch (Exception e) 
		{
			logger.error("[BoardDao] boardDeleteAll, SQL Exception", e);
		}

		return count;
	}
	
}
