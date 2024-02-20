package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.User;

public class UserDao 
{
	private static Logger logger = LogManager.getLogger(UserDao.class);
	
	//아이디 존재 확인
	public int udIdCount(String udId)
	{
		int count = 0;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT COUNT(UD_ID) CNT ");
		sql.append("  FROM USER_DATA ");
		sql.append(" WHERE UD_ID = ? ");
	
		try
		{
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setString(1, udId);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
				count = resultSet.getInt("CNT");	
		}
		catch (Exception e) 
		{
			logger.error("[UserDao] udIdCount, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement, connection);
		}
		return count;
	}
	
	//닉네임 존재 확인
	public int udNicknameCount(String udNickname)
	{
		int count = 0;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT COUNT(UD_NICKNAME) CNT ");
		sql.append("  FROM USER_DATA ");
		sql.append(" WHERE UD_NICKNAME = ? ");
		
		try
		{
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setString(1, udNickname);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
				count = resultSet.getInt("CNT");	
		}
		catch (Exception e) 
		{
			logger.error("[UserDao] udNicknameCount, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement, connection);
		}
		return count;
	}
	
	//이메일 존재 확인
	public int udEmailCount(String udEmail)
	{
		int count = 0;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT COUNT(UD_EMAIL) CNT ");
		sql.append("  FROM USER_DATA ");
		sql.append(" WHERE UD_EMAIL = ? ");
		
		try
		{
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setString(1, udEmail);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
				count = resultSet.getInt("CNT");	
		}
		catch (Exception e) 
		{
			logger.error("[UserDao] udEmailCount, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement, connection);
		}
		return count;
	}
	
	//전화번호 존재 확인
	public int udPhoneCount(String udPhone)
	{
		int count = 0;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT COUNT(UD_PHONE) CNT ");
		sql.append("  FROM USER_DATA ");
		sql.append(" WHERE UD_PHONE = ? ");
		
		try
		{
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setString(1, udPhone);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
				count = resultSet.getInt("CNT");	
		}
		catch (Exception e) 
		{
			logger.error("[UserDao] udPhoneCount, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement, connection);
		}
		return count;
	}
	
	
	//사용자 등록 (회원가입)
	public int userInsert(User user)
	{
		int count = 0;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO USER_DATA ");
		sql.append(" (UD_ID, UD_PWD, UD_NAME, UD_NICKNAME, UD_EMAIL, UD_PHONE, UD_STATUS, UD_REG_DATE, UD_AUTH) ");
		sql.append(" VALUES (?, ?, ?, ?, ?, ?, ?, SYSDATE, ?) ");
				
		try 
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			
			preparedStatement.setString(++cnt, user.getUdId());
			preparedStatement.setString(++cnt, user.getUdPwd());
			preparedStatement.setString(++cnt, user.getUdName());
			preparedStatement.setString(++cnt, user.getUdNickname());
			preparedStatement.setString(++cnt, user.getUdEmail());
			preparedStatement.setString(++cnt, user.getUdPhone());
			preparedStatement.setString(++cnt, user.getUdStatus());
			preparedStatement.setString(++cnt, user.getUdAuth());
		
			count = preparedStatement.executeUpdate();	
		} 
		catch (Exception e)
		{
			logger.error("[UserDao] userInsert, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(preparedStatement, connection);
		}
		return count;
	}
	
	//사용자 조회(로그인, 업데이트용)
	public User userSelect(String udId)
	{
		User user = null;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT UD_ID, ");
		sql.append("       UD_PWD, ");
		sql.append("       UD_NAME, ");
		sql.append("       UD_NICKNAME, ");
		sql.append("       UD_EMAIL, ");
		sql.append("       UD_PHONE, ");
		sql.append("       UD_STATUS, ");
		sql.append("       TO_CHAR(UD_REG_DATE, 'YYYY.MM.DD HH24:MI:SS') UD_REG_DATE, ");
		sql.append("       UD_AUTH ");
		sql.append("  FROM USER_DATA ");
		sql.append(" WHERE UD_ID = ? ");
		
		try 
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			preparedStatement.setString(++cnt, udId);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next())
			{
				user = new User();
				user.setUdId(resultSet.getString("UD_ID"));
				user.setUdPwd(resultSet.getString("UD_PWD"));
				user.setUdName(resultSet.getString("UD_NAME"));
				user.setUdNickname(resultSet.getString("UD_NICKNAME"));
				user.setUdEmail(resultSet.getString("UD_EMAIL"));
				user.setUdPhone(resultSet.getString("UD_PHONE"));
				user.setUdStatus(resultSet.getString("UD_STATUS"));
				user.setUdRegDate(resultSet.getString("UD_REG_DATE"));
				user.setUdAuth(resultSet.getString("UD_AUTH"));
			}
		} 
		catch (Exception e)
		{
			logger.error("[UserDao] userSelect, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(resultSet, preparedStatement, connection);
		}
		return user;
	}
	
	//사용자 정보 수정
	public int userUpdate(User user)
	{
		int count = 0;
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE USER_DATA SET ");
		sql.append("	   UD_PWD = ?, ");
		sql.append("	   UD_NICKNAME = ?, ");
		sql.append("	   UD_EMAIL = ?, ");
		sql.append("	   UD_PHONE = ? ");
		sql.append(" WHERE UD_ID = ? ");
				
		try
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			
			preparedStatement.setString(++cnt, user.getUdPwd());
			preparedStatement.setString(++cnt, user.getUdNickname());
			preparedStatement.setString(++cnt, user.getUdEmail());
			preparedStatement.setString(++cnt, user.getUdPhone());
			preparedStatement.setString(++cnt, user.getUdId());
			
			count = preparedStatement.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[UserDao] userUpdate, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(preparedStatement, connection);
		}
		return count;
	}
	
	//사용자 회원탈퇴, Status Y -> S
	public int userStatusUpdate(User user)
	{
		int count = 0;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE USER_DATA SET ");
		sql.append("       UD_STATUS = ? ");
		sql.append(" WHERE UD_ID = ? ");
		
		try
		{
			int cnt = 0;
			connection = DBManager.getConnection();
			preparedStatement = connection.prepareStatement(sql.toString());
			
			preparedStatement.setString(++cnt, user.getUdStatus());
			preparedStatement.setString(++cnt, user.getUdId());
			
			count = preparedStatement.executeUpdate();	
		}
		catch (Exception e) 
		{
			logger.error("[UserDao] userStatusUpdate, SQL Exception", e);
		}
		finally 
		{
			DBManager.close(preparedStatement, connection);
		}
		return count;
	}
}