package de.oklischat.mydocs.mongodb.spring.domain;

import java.io.Serializable;

public abstract class Entity implements Serializable {
	
	private static final long serialVersionUID = 3138830653909397166L;

	private String id;
	private Integer version = null;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

}
