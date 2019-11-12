/**
 * (c) 2019 by Andreas Muelder
 */
package org.yakindu.sct.generator.spring

import org.eclipse.xtext.generator.IFileSystemAccess
import org.yakindu.sct.generator.core.ISGraphGenerator
import org.yakindu.sct.model.sgen.GeneratorEntry
import org.yakindu.sct.model.sgraph.Entry
import org.yakindu.sct.model.sgraph.State
import org.yakindu.sct.model.sgraph.Statechart

class SpringGenerator implements ISGraphGenerator {

	override generate(Statechart statechart, GeneratorEntry entry, IFileSystemAccess access) {
		access.generateFile(statechart.name + "/" + statechart.name.toFirstUpper + 'Config.java', statechart.code);
	}

	def code(Statechart statechart) '''
		
			package «statechart.name»;
		
			«statechart.imports»
			
			@Configuration
			@EnableStateMachine
			public class «statechart.name.toFirstUpper»Config
		        extends EnumStateMachineConfigurerAdapter<States, Events> {
			
				public static enum States {
				    «FOR state : statechart.regions.map[vertices].flatten.filter(State) SEPARATOR ','»
				    	«state.name.toUpperCase»
				    «ENDFOR»
				}
				
				public static enum Events {
				    «FOR event : statechart.scopes.map[events].flatten SEPARATOR ','»
				    	«event.name.toUpperCase»
				    «ENDFOR»
				}
				
				  @Override
				  public void configure(StateMachineStateConfigurer<States, Events> states)
				          throws Exception {
				      states
				          .withStates()
				              .initial(States.«statechart.initialState»)
				              .states(EnumSet.allOf(States.class));
				  }
			
			    @Override
			    public void configure(StateMachineTransitionConfigurer<States, Events> transitions)
			            throws Exception {
			    «FOR transition : statechart.regions.head.vertices.filter(State).map[outgoingTransitions].flatten BEFORE 'transitions' SEPARATOR '.and()' AFTER ';'»
			    	.withExternal()
			    	.source(States.«transition.source.name.toUpperCase»)
			    	.target(States.«transition.target.name.toUpperCase»)
			    	.event(Events.«transition.specification.toUpperCase»)
			    	«ENDFOR»
			    	}
				
				}
		'''

	def protected initialState(Statechart it) {
		regions.head.vertices.filter(Entry).head.outgoingTransitions.head.target.name.toUpperCase
	}

	def protected imports(Statechart it) '''
		import java.util.EnumSet;
		import org.springframework.context.annotation.Configuration;
		import org.springframework.statemachine.config.EnableStateMachine;
		import org.springframework.statemachine.config.EnumStateMachineConfigurerAdapter;
		import org.springframework.statemachine.config.builders.StateMachineStateConfigurer;
		import org.springframework.statemachine.config.builders.StateMachineTransitionConfigurer;
		import «name».«name.toFirstUpper»Config.*;
	'''

}
