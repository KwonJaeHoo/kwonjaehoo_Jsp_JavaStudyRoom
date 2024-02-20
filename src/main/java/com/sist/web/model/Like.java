package com.sist.web.model;

import java.io.Serializable;

public class Like implements Serializable
{
	private static final long serialVersionUID = 1L;

	private long bdSeq;
	private String udId;
	
	public Like()
	{
		bdSeq = 0;
		udId = "";
	}
	
	public long getBdSeq() 
	{
		return bdSeq;
	}
	public void setBdSeq(long bdSeq)
	{
		this.bdSeq = bdSeq;
	}
	public String getUdId() 
	{
		return udId;
	}
	public void setUdId(String udId) 
	{
		this.udId = udId;
	}
}