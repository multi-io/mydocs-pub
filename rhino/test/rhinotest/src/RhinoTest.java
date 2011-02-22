import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

import javax.script.Invocable;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

import sun.org.mozilla.javascript.internal.Scriptable;

public class RhinoTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		ScriptEngineManager seMgr = new ScriptEngineManager();
		ScriptEngine jsEngine = seMgr.getEngineByName("JavaScript");
		Invocable jsEngineInvocable = (Invocable) jsEngine;
		jsEngine.eval(new FileReader("formValidation.js"));
		Map<String, String[]> formData = new HashMap<String, String[]>();
		formData.put("height", new String[]{"360"});
		Object retval = jsEngineInvocable.invokeFunction("validate", formData, 1);
		Scriptable retvalJsobj = (Scriptable) retval;
		for (Object id : retvalJsobj.getIds()) {
			if (id instanceof String) {
				System.out.println((String)id + " => " + retvalJsobj.get((String)id, retvalJsobj).toString());
			}
		}
	}

}
