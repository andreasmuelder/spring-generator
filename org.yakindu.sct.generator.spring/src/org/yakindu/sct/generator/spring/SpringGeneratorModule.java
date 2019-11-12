/**
 * (c) 2019 by Andreas Muelder
 */
package org.yakindu.sct.generator.spring;

import org.yakindu.sct.generator.core.IGeneratorModule;
import org.yakindu.sct.generator.core.ISGraphGenerator;
import org.yakindu.sct.model.sgen.GeneratorEntry;

import com.google.inject.Binder;

public class SpringGeneratorModule implements IGeneratorModule {

	public void configure(GeneratorEntry entry, Binder binder) {
		binder.bind(ISGraphGenerator.class).to(SpringGenerator.class);
	}
}
