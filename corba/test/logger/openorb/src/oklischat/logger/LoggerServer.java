package oklischat.logger;

import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.NavigableSet;
import java.util.TreeSet;

public class LoggerServer extends LoggerPOA {
	
	public static final int MAX_MSG_COUNT = 1000;
	
	private Comparator<LogMessage> logMsgComparator = new Comparator<LogMessage>() {
		@Override
		public int compare(LogMessage m1, LogMessage m2) {
			// TODO Auto-generated method stub
			return 0;
		}
	};
	
	private NavigableSet<LogMessage> logMessages = new TreeSet<LogMessage>(logMsgComparator) {
		@Override
		public boolean add(LogMessage e) {
			boolean result = super.add(e);
			while (this.size() > MAX_MSG_COUNT) {
				Iterator<LogMessage> it = this.iterator();
				it.next();
				it.remove();
			}
			return result;
			//TODO: would have to override all modifying methods (fragile base class)
		}
	};

	@Override
	public void log(int prio, String message) {
		LogMessage msg = new LogMessage(1, message, (int)(new Date().getTime()/1000));
		logMessages.add(msg);
		System.out.println("[date=" + new Date(msg.timestamp) + ", prio=" + prio + ": " + msg.message);
	}
	
	@Override
	public LogMessage getFirstLogMessage(int startTimestamp) {
		// TODO Auto-generated method stub
		return null;
	}
}
