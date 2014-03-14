/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package it.eng.spagobi.engines.whatif.services.common;

import it.eng.spagobi.engines.whatif.WhatIfEngineInstance;
import it.eng.spagobi.engines.whatif.services.serializer.SerializationException;
import it.eng.spagobi.engines.whatif.services.serializer.SerializationManager;
import it.eng.spagobi.utilities.engines.EngineConstants;
import it.eng.spagobi.utilities.engines.SpagoBIEngineRuntimeException;
import it.eng.spagobi.utilities.engines.rest.AbstractRestService;
import it.eng.spagobi.utilities.engines.rest.ExecutionSession;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;

import org.apache.log4j.Logger;

import com.eyeq.pivot4j.PivotModel;

/**
 * 
 * @author Zerbetto Davide (davide.zerbetto@eng.it), Alberto Ghedin (alberto.ghedin@eng.it)
 *
 */
public class AbstractWhatIfEngineService extends AbstractRestService{

	private static final String OUTPUTFORMAT = "OUTPUTFORMAT";
	private static final String OUTPUTFORMAT_JSONHTML = "application/json";
	
	
	public static transient Logger logger = Logger.getLogger(AbstractWhatIfEngineService.class);

	@Context
	protected HttpServletRequest servletRequest;
	
	/**
	 * Renders the model and return the HTML table
	 * @param request
	 * @return the String that contains the HTML table
	 */
	public String renderModel(PivotModel model){
		logger.debug("IN");
		
		String serializedModel = null;
	

		try {
			serializedModel = (String) serialize(model);
		} catch (SerializationException e) {
			logger.error("Error serializing the pivot", e);
			throw new SpagoBIEngineRuntimeException("Error serializing the pivot",e);
		}

		
		logger.debug("OUT: table correctly serialized");
		return serializedModel;

	}

	public HttpServletRequest getServletRequest(){
		return servletRequest;
	}
	
	/**
	 * Gets the what if engine instance.
	 * 
	 * @return the console engine instance
	 */
	public WhatIfEngineInstance getWhatIfEngineInstance() {
		ExecutionSession es = getExecutionSession();
		return (WhatIfEngineInstance)es.getAttributeFromSession( EngineConstants.ENGINE_INSTANCE );

	}
	
	public String getOutputFormat(){
		String outputFormat = servletRequest.getParameter(OUTPUTFORMAT);
		
		if(outputFormat==null  || outputFormat.equals("") ){
			logger.debug("the output format is null.. use the default one"+OUTPUTFORMAT_JSONHTML);
			outputFormat = OUTPUTFORMAT_JSONHTML;
		}

		return outputFormat;
	}
	
	public String serialize(Object obj) throws SerializationException{
		String outputFormat = getOutputFormat();
		return (String) SerializationManager.serialize(outputFormat, obj);
	}

	public Object deserialize(String obj, Class clazz) throws SerializationException{
		String outputFormat = getOutputFormat();
		return SerializationManager.deserialize(outputFormat, obj, clazz);
	}
	
}
