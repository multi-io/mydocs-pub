package de.oklischat.mydocs.mongodb.spring;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import de.oklischat.mydocs.mongodb.spring.domain.Person;
import de.oklischat.mydocs.mongodb.spring.persistence.PersonService;

import static org.junit.Assert.*;

@Service
public class TestPersistence {

	private PersonService personService;

	@Autowired
	public TestPersistence(PersonService personService) {
		this.personService = personService;
	}

	public void testPersisting() {
		Person p = new Person("Paul", 42);
		assertEquals("Paul", p.getName());
		assertNull(p.getId());
		personService.persist(p);
		String pId = p.getId();
		assertNotNull(pId);
		assertEquals(new Integer(1), p.getVersion());

		p.setName("Paulina");
		assertEquals("Paulina", p.getName());
		personService.persist(p);
		assertEquals(pId, p.getId());
		assertEquals(new Integer(2), p.getVersion());

		p.setName("P3");
		p.setVersion(1);
		try {
			personService.persist(p);
			fail("IllegalArgumentException expected");
		} catch (IllegalArgumentException e) {
		}
		assertEquals(pId, p.getId());
		assertEquals(new Integer(1), p.getVersion());

		personService.persist(p, true);
		assertEquals(new Integer(3), p.getVersion());

		//TODO: white-box testing of DB contents
	}


	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
        ApplicationContext context = new ClassPathXmlApplicationContext("/applicationContext.xml");
        TestPersistence tp = (TestPersistence) context.getBean("testPersistence");
        tp.testPersisting();
	}

}
