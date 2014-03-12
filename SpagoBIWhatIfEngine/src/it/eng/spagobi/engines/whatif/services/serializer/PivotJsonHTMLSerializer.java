 /* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/**
 * 
 * Renderer of the model...
 * It uses the WhatIfHTMLRenderer to render the table in a HTML format
 * 
 * @author Alberto Ghedin (alberto.ghedin@eng.it)
 */
package it.eng.spagobi.engines.whatif.services.serializer;

import it.eng.spagobi.pivot4j.ui.WhatIfHTMLRenderer;
import it.eng.spagobi.utilities.engines.SpagoBIEngineRuntimeException;
import it.eng.spagobi.utilities.exceptions.SpagoBIRuntimeException;

import java.io.IOException;
import java.io.StringWriter;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.olap4j.Axis;
import org.olap4j.CellSet;
import org.olap4j.CellSetAxis;
import org.olap4j.metadata.Hierarchy;

import com.eyeq.pivot4j.PivotModel;
import com.eyeq.pivot4j.ui.command.DrillCollapseMemberCommand;
import com.eyeq.pivot4j.ui.command.DrillCollapsePositionCommand;
import com.eyeq.pivot4j.ui.command.DrillDownCommand;
import com.eyeq.pivot4j.ui.command.DrillDownReplaceCommand;
import com.eyeq.pivot4j.ui.command.DrillExpandMemberCommand;
import com.eyeq.pivot4j.ui.command.DrillExpandPositionCommand;
import com.eyeq.pivot4j.ui.command.DrillUpReplaceCommand;

public class PivotJsonHTMLSerializer {

	public static transient Logger logger = Logger.getLogger(PivotJsonHTMLSerializer.class);
	
	private static final String NAME= "name";
	private static final String UNIQUE_NAME= "uniqueName";
	private static final String COLUMNS= "columns";
	private static final String ROWS= "rows";
	private static final String FILTERS= "filters";
	private static final String TABLE= "table";
	private static final String POSITION= "position";
	private static final String AXIS= "axis";
	private static final String ROWSAXISORDINAL = "rowsAxisOrdinal";
	private static final String COLUMNSAXISORDINAL = "columnsAxisOrdinal";
    
	
	
	public static String renderModel(PivotModel model){

		logger.debug("IN");
		String table="";
		JSONObject pivot = new JSONObject();
		
		
		logger.debug("Creating the renderer");
		StringWriter writer = new StringWriter();
		WhatIfHTMLRenderer renderer = new WhatIfHTMLRenderer(writer);
		
		logger.debug("Setting the properties of the renderer");
		
		renderer.setShowDimensionTitle(false); // Optionally hide the dimension title headers.
		renderer.setShowParentMembers(true); // Optionally make the parent members visible.
		
		
		renderer.setCellSpacing(0);
		renderer.setRowHeaderStyleClass("x-column-header-inner x-column-header x-column-header-align-left x-box-item x-column-header-default x-unselectable x-grid-header-ct x-docked x-grid-header-ct-default x-docked-top x-grid-header-ct-docked-top x-grid-header-ct-default-docked-top x-box-layout-ct x-docked-noborder-top x-docked-noborder-right x-docked-noborder-left x-pivot-header");
		renderer.setColumnHeaderStyleClass("x-column-header-inner x-column-header x-column-header-align-left x-box-item x-column-header-default x-unselectable x-grid-header-ct x-docked x-grid-header-ct-default x-docked-top x-grid-header-ct-docked-top x-grid-header-ct-default-docked-top x-box-layout-ct x-docked-noborder-top x-docked-noborder-right x-docked-noborder-left x-pivot-header");
		renderer.setCornerStyleClass("x-column-header-inner x-column-header x-column-header-align-left x-box-item x-column-header-default x-unselectable x-grid-header-ct x-docked x-grid-header-ct-default x-docked-top x-grid-header-ct-docked-top x-grid-header-ct-default-docked-top x-box-layout-ct x-docked-noborder-top x-docked-noborder-right x-docked-noborder-left x-pivot-header");
		renderer.setCellStyleClass("x-grid-cell x-grid-td x-grid-cell-gridcolumn-1014 x-unselectable x-grid-cell-inner  x-grid-row-alt x-grid-data-row x-grid-with-col-lines x-grid-cell x-pivot-cell");
		renderer.setTableStyleClass("x-panel-body x-grid-body x-panel-body-default x-box-layout-ct x-panel-body-default x-pivot-table");

		
		renderer.setEnableColumnDrillDown(true);
		renderer.setEnableRowDrillDown(true);
		renderer.setEnableSort(true);
		String drillDownModeValue = DrillDownCommand.MODE_POSITION;
//		if(drillDownMode != null){
//			drillDownModeValue = drillDownMode;
//		}
		
		if(drillDownModeValue.equals(DrillDownCommand.MODE_POSITION)){
			renderer.addCommand(new DrillExpandPositionCommand(renderer));
			renderer.addCommand(new DrillCollapsePositionCommand(renderer));
		}else if(drillDownModeValue.equals(DrillDownCommand.MODE_MEMBER)){
			renderer.addCommand(new DrillCollapseMemberCommand(renderer));
			renderer.addCommand(new DrillExpandMemberCommand(renderer));	
		}else if(drillDownModeValue.equals(DrillDownCommand.MODE_REPLACE)){
			renderer.addCommand(new DrillDownReplaceCommand(renderer));
			renderer.addCommand(new DrillUpReplaceCommand(renderer));		
		}
		
		renderer.setDrillDownMode(drillDownModeValue);
		
		logger.debug("Rendering the model");
		renderer.render(model);

		
		try {
			writer.flush();
			writer.close();
			table = writer.getBuffer().toString();
		} catch (IOException e) {
			logger.error("Error serializing the table",e);
			throw new SpagoBIEngineRuntimeException("Error serializing the table",e);
		}

		CellSet cellSet = model.getCellSet();
		List<CellSetAxis> axis = cellSet.getAxes();
		
		try {
			
			List<Hierarchy> axisHierarchies = axis.get(0).getAxisMetaData().getHierarchies();
			axisHierarchies.addAll(axis.get(1).getAxisMetaData().getHierarchies());
			List otherHierarchies = model.getCube().getHierarchies();
			
			otherHierarchies.removeAll(axisHierarchies);
			
			
			pivot.put(TABLE, table);
			pivot.put(ROWS, serializeAxis(axis, Axis.ROWS));
			pivot.put(COLUMNS,  serializeAxis(axis, Axis.COLUMNS));
			pivot.put(FILTERS,  serializeHierarchies(otherHierarchies, -1));
			pivot.put(COLUMNSAXISORDINAL, Axis.COLUMNS.axisOrdinal());
			pivot.put(ROWSAXISORDINAL, Axis.ROWS.axisOrdinal());
			
		} catch (Exception e) {
			logger.error("Error serializing the pivot table", e);
			throw new SpagoBIRuntimeException("Error serializing the pivot table", e);
		}

		
		
		
		logger.debug("OUT");
		
		return pivot.toString();
	}
	
	private static JSONArray serializeAxis(List<CellSetAxis> axis, Axis type) throws JSONException{
		CellSetAxis aAxis= axis.get(0);
		int axisPos = 0;
		if(!aAxis.getAxisOrdinal().equals(type)){
			aAxis = axis.get(1);
			axisPos = 1;
		}
		List<Hierarchy> hierarchies = aAxis.getAxisMetaData().getHierarchies();
		return serializeHierarchies(hierarchies, axisPos);
		
	}

	
	private static JSONArray serializeHierarchies(List<Hierarchy> hierarchies, int axis) throws JSONException{
		JSONArray hierchiesSerialized = new JSONArray();
		if(hierarchies!=null){
			for (int i=0; i<hierarchies.size(); i++) {
				Hierarchy hierarchy = hierarchies.get(i);
				JSONObject hierarchyObject = new JSONObject();
				hierarchyObject.put(NAME, hierarchy.getName());
				hierarchyObject.put(UNIQUE_NAME, hierarchy.getUniqueName());
				hierarchyObject.put(POSITION, hierarchy.getName());
				hierarchyObject.put(AXIS, axis);
				hierchiesSerialized.put(hierarchyObject);
			}
		}
		return hierchiesSerialized;
	}
	
}
