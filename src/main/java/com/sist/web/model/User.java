package com.sist.web.model;

import java.io.Serializable;

public class User implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private String udId;
	private String udPwd;
	private String udName;
	private String udNickname;
	private String udEmail;
	private String udPhone;
	private String udStatus;
	private String udRegDate;
	private String udAuth;
	
	public User()
	{
		udId = "";
		udPwd = "";
		udName = "";
		udNickname = "";
		udEmail = "";
		udPhone = "";
		udStatus = "N";
		udRegDate = "";
		udAuth = "U";
	}
	
	public String getUdId() 
	{
		return udId;
	}
	public void setUdId(String udId) 
	{
		this.udId = udId;
	}
	public String getUdPwd() 
	{
		return udPwd;
	}
	public void setUdPwd(String udPwd) 
	{
		this.udPwd = udPwd;
	}
	public String getUdName() 
	{
		return udName;
	}
	public void setUdName(String udName) 
	{
		this.udName = udName;
	}
	public String getUdNickname() 
	{
		return udNickname;
	}
	public void setUdNickname(String udNickname) 
	{
		this.udNickname = udNickname;
	}
	public String getUdEmail() 
	{
		return udEmail;
	}
	public void setUdEmail(String udEmail) 
	{
		this.udEmail = udEmail;
	}
	public String getUdPhone() 
	{
		return udPhone;
	}
	public void setUdPhone(String udPhone) 
	{
		this.udPhone = udPhone;
	}
	public String getUdStatus() 
	{
		return udStatus;
	}
	public void setUdStatus(String udStatus) 
	{
		this.udStatus = udStatus;
	}
	public String getUdRegDate() 
	{
		return udRegDate;
	}
	public void setUdRegDate(String udRegDate) 
	{
		this.udRegDate = udRegDate;
	}
	public String getUdAuth() 
	{
		return udAuth;
	}
	public void setUdAuth(String udAuth) 
	{
		this.udAuth = udAuth;
	}	
}
