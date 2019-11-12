package turnstile;

/**
 * 
 * @author andreas muelder - Initial contribution and API
 * 
 */
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.statemachine.StateMachine;
import org.springframework.statemachine.config.EnableStateMachine;
import org.springframework.statemachine.listener.StateMachineListenerAdapter;
import org.springframework.statemachine.state.State;

import turnstile.TurnstileConfig.Events;
import turnstile.TurnstileConfig.States;

@SpringBootApplication
@EnableStateMachine
public class Application implements CommandLineRunner {

	private final StateMachine<States, Events> stateMachine;

	@Autowired
	public Application(StateMachine<States, Events> stateMachine) {
		this.stateMachine = stateMachine;
		stateMachine.addStateListener(new StatemachineLogger());
	}

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	@Override
	public void run(String... args) {
		stateMachine.start();
		System.out.println("Sending Event COIN");
		stateMachine.sendEvent(Events.COIN);
		System.out.println("Sending Event PUSH");
		stateMachine.sendEvent(Events.PUSH);
		stateMachine.stop();
	}

	public static class StatemachineLogger extends StateMachineListenerAdapter<States, Events> {

		@Override
		public void stateEntered(State<States, Events> state) {
			System.out.println("stateEntered: " + state);
		}

		@Override
		public void stateExited(State<States, Events> state) {
			System.out.println("stateExited: " + state);
		}
	}
}