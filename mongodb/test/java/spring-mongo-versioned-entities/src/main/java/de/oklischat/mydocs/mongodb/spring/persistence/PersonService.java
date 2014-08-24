package de.oklischat.mydocs.mongodb.spring.persistence;

import static org.springframework.data.mongodb.core.query.Criteria.where;
import static org.springframework.data.mongodb.core.query.Query.query;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import de.oklischat.mydocs.mongodb.spring.domain.Person;

@Service
public class PersonService extends EntityPersister<Person> {
	
	protected static final Logger logger = Logger.getLogger(PersonService.class);

	@Autowired
	public PersonService(MongoTemplate mongoTemplate) {
		super(mongoTemplate);
	}

	public List<Person> findByName(String name, int firstRowNr, int rowsCount) {
		Query q = query(where("name").is(name)).skip(firstRowNr).limit(rowsCount);
		//q.sort().on("name", Order.ASCENDING);
		return getMongoTemplate().find(q, Person.class);
	}
	
}
