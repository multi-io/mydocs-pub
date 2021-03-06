package de.oklischat.mydocs.mongodb.spring.persistence;

import static org.springframework.data.mongodb.core.query.Criteria.where;
import static org.springframework.data.mongodb.core.query.Query.query;

import java.lang.reflect.ParameterizedType;

import org.apache.log4j.Logger;
import org.springframework.data.mongodb.core.FindAndModifyOptions;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Update;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

import de.oklischat.mydocs.mongodb.spring.domain.Entity;

public class EntityPersister<EntityType extends Entity> {
	
	protected static final Logger logger = Logger.getLogger(EntityPersister.class);

	/**
	 * EntityType (generics parameter), but available at runtime
	 */
	private final Class<EntityType> entityType;

	private final MongoTemplate mongoTemplate;
	//private final AtomicCounterService counterSvc;

	/**
	 * When instantiating this class directly, you have to pass the entity type (the generic parameter)
	 * to the constructor because otherwise it wouldn't be available at runtime due to limitations to
	 * Java's generics implementation (type erasure).
	 * 
	 * @param entityType
	 */
	public EntityPersister(Class<EntityType> entityType, MongoTemplate mongoTemplate) {
		this.entityType = entityType;
		this.mongoTemplate = mongoTemplate;
	}
	
	/**
	 * C'tor to be used by subclasses. Determines the entity type internally from generics information
	 * written into the subclass's .class file by the compiler.
	 */
	@SuppressWarnings("unchecked")
	protected EntityPersister(MongoTemplate mongoTemplate) {
		this.mongoTemplate = mongoTemplate;
		ParameterizedType superclass = (ParameterizedType) this.getClass().getGenericSuperclass();
		if (superclass == null || ! superclass.getRawType().equals(EntityPersister.class) || superclass.getActualTypeArguments().length != 1) {
			throw new IllegalArgumentException("Can't determine entity type at runtime when" +
					" SimpleEntityPersister isn't used as a base class. Pass the entity type to the constructor explicitly");
		}
		this.entityType = (Class<EntityType>) superclass.getActualTypeArguments()[0];
	}
	
	public MongoTemplate getMongoTemplate() {
		return mongoTemplate;
	}
	
	public EntityType findById(String id) {
		return mongoTemplate.findById(id, entityType);
	}
	
	/**
	 * 
	 * @param o
	 * @return
	 * @throws VersionConflictException if the object was already newer in the database
	 */
	public EntityType persist(EntityType o) {
		return persist(o, false);
	}

	/**
	 * 
	 * @param entity
	 * @param ignoreVersion if true, persist o even if it wasn't up-to-date
	 * @throws VersionConflictException if the object was already newer in the database. Won't happen if ignoreVersion.
	 * @return 
	 */
	public EntityType persist(EntityType entity, boolean ignoreVersion) {
		final String prevId = entity.getId();
		final Integer prevVersion = entity.getVersion();
        if ((prevId == null) != (prevVersion == null)) {
            throw new IllegalStateException("persisting a non-new object without a version, or a new object with a version, is not supported");
        }
		if (prevId == null) {
			//create new entity
			entity.setVersion(1);
			logger.debug("insert");
			mongoTemplate.insert(entity);
			assert(entity.getId() != null); //mongodb has chosen a new ID
			logger.debug("SUCCESS insert, id=" + entity.getId());
		} else {
			//update existing entity
			logger.debug("update " + prevId);
			Criteria queryCrit = where("id").is(prevId);
			if (!ignoreVersion) {
				queryCrit = queryCrit.and("version").is(prevVersion);
			}
			BasicDBObject dbObject = new BasicDBObject();
			mongoTemplate.getConverter().write(entity, dbObject);
			Update update = createUpdateForDBObject(dbObject);
			if (!ignoreVersion) {
				update.set("version", prevVersion + 1);
			} else {
				update.inc("version", 1);
			}
			//atomic query & update
			EntityType newEntity = mongoTemplate.findAndModify(query(queryCrit), update, FindAndModifyOptions.options().returnNew(true), entityType);
			if (newEntity == null) {
				//TODO: differentiate between the two cases
				throw new IllegalArgumentException("object not up-to-date, or no longer in the DB: id=" + prevId + ", version=" + prevVersion);
			} else {
				entity.setVersion(newEntity.getVersion());
			}
			logger.debug("SUCCESS update " + prevId + " to " + entity.getVersion());
		}
		return entity;
	}

	private Update createUpdateForDBObject(DBObject dbobj) {
		Update result = new Update();
		for (String key : dbobj.keySet()) {
			if ("_id".equals(key) || "version".equals(key)) {
				continue;
			}
			result.set(key, dbobj.get(key));
		}
		return result;
	}
	
	public void remove(EntityType entity) {
		//TODO
	}

}
