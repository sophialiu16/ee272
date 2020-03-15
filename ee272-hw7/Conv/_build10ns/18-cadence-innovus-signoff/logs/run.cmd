#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Fri Mar 13 19:29:36 2020                
#                                                     
#######################################################

#@(#)CDS: Innovus v19.10-p002_1 (64bit) 04/19/2019 15:18 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 19.10-p002_1 NR190418-1643/19_10-UB (database version 18.20, 458.7.1) {superthreading v1.51}
#@(#)CDS: AAE 19.10-b002 (64bit) 04/19/2019 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 19.10-p002_1 () Apr 19 2019 06:39:48 ( )
#@(#)CDS: SYNTECH 19.10-b001_1 () Apr  4 2019 03:00:51 ( )
#@(#)CDS: CPE v19.10-p002
#@(#)CDS: IQuantus/TQuantus 19.1.0-e101 (64bit) Thu Feb 28 10:29:46 PST 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
is_common_ui_mode
restoreDesign /home/users/sophliu/ee272/ee272-hw7/Conv/build/17-cadence-innovus-postroute_hold/checkpoints/design.checkpoint/save.enc.dat Conv
setDistributeHost -local
setMultiCpuUsage -localCpu 16
setDistributeHost -local
setMultiCpuUsage -localCpu 16
um::push_snapshot_stack
setDesignMode -process 45
setExtractRCMode -coupled true -effortLevel low
setAnalysisMode -analysisType onChipVariation -cppr both
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner [get_analysis_view $view -delay_corner]  -rc_corner
get_analysis_view $view -delay_corner
get_delay_corner [get_analysis_view $view -delay_corner]  -rc_corner
get_rc_corner $corner -qx_tech_file
setExtractRCMode -engine postRoute -effortLevel low -coupled true
extractRC
rcOut -rc_corner typical -spef typical.spef.gz
timeDesign -prefix signoff -signoff -reportOnly -outDir reports -expandedViews
timeDesign -prefix signoff -signoff -reportOnly -hold -outDir reports -expandedViews
streamOut results/Conv.gds.gz -units 1000 -mapFile inputs/adk/rtk-stream-out.map
summaryReport -noHtml -outfile reports/signoff.summaryReport.rpt
verifyConnectivity -noAntenna
verify_drc
verifyProcessAntenna
um::pop_snapshot_stack
getOptMode -multiBitFlopOpt -quiet
get_metric -raw -id current -uuid 370c8925-2d07-4219-880f-0d9dd9d26b62 clock.Routing.area.total
get_metric -raw -id current -uuid 370c8925-2d07-4219-880f-0d9dd9d26b62 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 370c8925-2d07-4219-880f-0d9dd9d26b62 clock.eGRPC.area.total
get_metric -raw -id current -uuid 370c8925-2d07-4219-880f-0d9dd9d26b62 clock.Routing.area.total
get_metric -raw -id current -uuid 370c8925-2d07-4219-880f-0d9dd9d26b62 clock.Implementation.area.total
get_metric -raw -id current -uuid 370c8925-2d07-4219-880f-0d9dd9d26b62 clock.eGRPC.area.total
get_metric -raw -id current -uuid 370c8925-2d07-4219-880f-0d9dd9d26b62 clock.Construction.area.total
get_metric -raw -id current -uuid 370c8925-2d07-4219-880f-0d9dd9d26b62 clock.Implementation.area.total
get_metric -raw -id current -uuid 6dfc155d-7c06-4acb-8308-9c10b4b4403b clock.Routing.area.total
get_metric -raw -id current -uuid 6dfc155d-7c06-4acb-8308-9c10b4b4403b clock.PostConditioning.area.total
get_metric -raw -id current -uuid 6dfc155d-7c06-4acb-8308-9c10b4b4403b clock.eGRPC.area.total
get_metric -raw -id current -uuid 6dfc155d-7c06-4acb-8308-9c10b4b4403b clock.Routing.area.total
get_metric -raw -id current -uuid 6dfc155d-7c06-4acb-8308-9c10b4b4403b clock.Implementation.area.total
get_metric -raw -id current -uuid 6dfc155d-7c06-4acb-8308-9c10b4b4403b clock.eGRPC.area.total
get_metric -raw -id current -uuid 6dfc155d-7c06-4acb-8308-9c10b4b4403b clock.Construction.area.total
get_metric -raw -id current -uuid 6dfc155d-7c06-4acb-8308-9c10b4b4403b clock.Implementation.area.total
get_metric -raw -id current -uuid 6958850f-294c-48e5-a787-dcc1b0a3ab1a clock.Routing.area.total
get_metric -raw -id current -uuid 6958850f-294c-48e5-a787-dcc1b0a3ab1a clock.PostConditioning.area.total
get_metric -raw -id current -uuid 6958850f-294c-48e5-a787-dcc1b0a3ab1a clock.eGRPC.area.total
get_metric -raw -id current -uuid 6958850f-294c-48e5-a787-dcc1b0a3ab1a clock.Routing.area.total
get_metric -raw -id current -uuid 6958850f-294c-48e5-a787-dcc1b0a3ab1a clock.Implementation.area.total
get_metric -raw -id current -uuid 6958850f-294c-48e5-a787-dcc1b0a3ab1a clock.eGRPC.area.total
get_metric -raw -id current -uuid 6958850f-294c-48e5-a787-dcc1b0a3ab1a clock.Construction.area.total
get_metric -raw -id current -uuid 6958850f-294c-48e5-a787-dcc1b0a3ab1a clock.Implementation.area.total
get_metric -raw -id current -uuid 22a4fcb8-d261-4aca-8ead-77f41ca2f011 clock.Routing.area.total
get_metric -raw -id current -uuid 22a4fcb8-d261-4aca-8ead-77f41ca2f011 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 22a4fcb8-d261-4aca-8ead-77f41ca2f011 clock.eGRPC.area.total
get_metric -raw -id current -uuid 22a4fcb8-d261-4aca-8ead-77f41ca2f011 clock.Routing.area.total
get_metric -raw -id current -uuid 22a4fcb8-d261-4aca-8ead-77f41ca2f011 clock.Implementation.area.total
get_metric -raw -id current -uuid 22a4fcb8-d261-4aca-8ead-77f41ca2f011 clock.eGRPC.area.total
get_metric -raw -id current -uuid 22a4fcb8-d261-4aca-8ead-77f41ca2f011 clock.Construction.area.total
get_metric -raw -id current -uuid 22a4fcb8-d261-4aca-8ead-77f41ca2f011 clock.Implementation.area.total
get_metric -raw -id current -uuid 55e23d4e-aae5-45ad-a95c-a1c0f26fd6e8 clock.Routing.area.total
get_metric -raw -id current -uuid 55e23d4e-aae5-45ad-a95c-a1c0f26fd6e8 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 55e23d4e-aae5-45ad-a95c-a1c0f26fd6e8 clock.eGRPC.area.total
get_metric -raw -id current -uuid 55e23d4e-aae5-45ad-a95c-a1c0f26fd6e8 clock.Routing.area.total
get_metric -raw -id current -uuid 55e23d4e-aae5-45ad-a95c-a1c0f26fd6e8 clock.Implementation.area.total
get_metric -raw -id current -uuid 55e23d4e-aae5-45ad-a95c-a1c0f26fd6e8 clock.eGRPC.area.total
get_metric -raw -id current -uuid 55e23d4e-aae5-45ad-a95c-a1c0f26fd6e8 clock.Construction.area.total
get_metric -raw -id current -uuid 55e23d4e-aae5-45ad-a95c-a1c0f26fd6e8 clock.Implementation.area.total
get_metric -raw -id current -uuid c9a7d7e0-10e8-4593-a148-b762a6d6f18b clock.Routing.area.total
get_metric -raw -id current -uuid c9a7d7e0-10e8-4593-a148-b762a6d6f18b clock.PostConditioning.area.total
get_metric -raw -id current -uuid c9a7d7e0-10e8-4593-a148-b762a6d6f18b clock.eGRPC.area.total
get_metric -raw -id current -uuid c9a7d7e0-10e8-4593-a148-b762a6d6f18b clock.Routing.area.total
get_metric -raw -id current -uuid c9a7d7e0-10e8-4593-a148-b762a6d6f18b clock.Implementation.area.total
get_metric -raw -id current -uuid c9a7d7e0-10e8-4593-a148-b762a6d6f18b clock.eGRPC.area.total
get_metric -raw -id current -uuid c9a7d7e0-10e8-4593-a148-b762a6d6f18b clock.Construction.area.total
get_metric -raw -id current -uuid c9a7d7e0-10e8-4593-a148-b762a6d6f18b clock.Implementation.area.total
get_metric -raw -id current -uuid 8202babf-9fdd-42ab-8bac-891213da4ba5 clock.Routing.area.total
get_metric -raw -id current -uuid 8202babf-9fdd-42ab-8bac-891213da4ba5 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 8202babf-9fdd-42ab-8bac-891213da4ba5 clock.eGRPC.area.total
get_metric -raw -id current -uuid 8202babf-9fdd-42ab-8bac-891213da4ba5 clock.Routing.area.total
get_metric -raw -id current -uuid 8202babf-9fdd-42ab-8bac-891213da4ba5 clock.Implementation.area.total
get_metric -raw -id current -uuid 8202babf-9fdd-42ab-8bac-891213da4ba5 clock.eGRPC.area.total
get_metric -raw -id current -uuid 8202babf-9fdd-42ab-8bac-891213da4ba5 clock.Construction.area.total
get_metric -raw -id current -uuid 8202babf-9fdd-42ab-8bac-891213da4ba5 clock.Implementation.area.total
get_metric -raw -id current -uuid 3f519b26-5961-4c12-a1e0-cf046e151d7c clock.Routing.area.total
get_metric -raw -id current -uuid 3f519b26-5961-4c12-a1e0-cf046e151d7c clock.PostConditioning.area.total
get_metric -raw -id current -uuid 3f519b26-5961-4c12-a1e0-cf046e151d7c clock.eGRPC.area.total
get_metric -raw -id current -uuid 3f519b26-5961-4c12-a1e0-cf046e151d7c clock.Routing.area.total
get_metric -raw -id current -uuid 3f519b26-5961-4c12-a1e0-cf046e151d7c clock.Implementation.area.total
get_metric -raw -id current -uuid 3f519b26-5961-4c12-a1e0-cf046e151d7c clock.eGRPC.area.total
get_metric -raw -id current -uuid 3f519b26-5961-4c12-a1e0-cf046e151d7c clock.Construction.area.total
get_metric -raw -id current -uuid 3f519b26-5961-4c12-a1e0-cf046e151d7c clock.Implementation.area.total
get_metric -raw -id current -uuid 5ea651d5-b72b-4960-ae8d-96319a207284 clock.Routing.area.total
get_metric -raw -id current -uuid 5ea651d5-b72b-4960-ae8d-96319a207284 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 5ea651d5-b72b-4960-ae8d-96319a207284 clock.eGRPC.area.total
get_metric -raw -id current -uuid 5ea651d5-b72b-4960-ae8d-96319a207284 clock.Routing.area.total
get_metric -raw -id current -uuid 5ea651d5-b72b-4960-ae8d-96319a207284 clock.Implementation.area.total
get_metric -raw -id current -uuid 5ea651d5-b72b-4960-ae8d-96319a207284 clock.eGRPC.area.total
get_metric -raw -id current -uuid 5ea651d5-b72b-4960-ae8d-96319a207284 clock.Construction.area.total
get_metric -raw -id current -uuid 5ea651d5-b72b-4960-ae8d-96319a207284 clock.Implementation.area.total
get_metric -raw -id current -uuid bfb6bacf-4c8d-4ccb-8a11-7bc5c1539a3d clock.Routing.area.total
get_metric -raw -id current -uuid bfb6bacf-4c8d-4ccb-8a11-7bc5c1539a3d clock.PostConditioning.area.total
get_metric -raw -id current -uuid bfb6bacf-4c8d-4ccb-8a11-7bc5c1539a3d clock.eGRPC.area.total
get_metric -raw -id current -uuid bfb6bacf-4c8d-4ccb-8a11-7bc5c1539a3d clock.Routing.area.total
get_metric -raw -id current -uuid bfb6bacf-4c8d-4ccb-8a11-7bc5c1539a3d clock.Implementation.area.total
get_metric -raw -id current -uuid bfb6bacf-4c8d-4ccb-8a11-7bc5c1539a3d clock.eGRPC.area.total
get_metric -raw -id current -uuid bfb6bacf-4c8d-4ccb-8a11-7bc5c1539a3d clock.Construction.area.total
get_metric -raw -id current -uuid bfb6bacf-4c8d-4ccb-8a11-7bc5c1539a3d clock.Implementation.area.total
get_metric -raw -id current -uuid 5263ebaf-1b0d-4cb7-994c-43151f6c8e3d clock.Routing.area.total
get_metric -raw -id current -uuid 5263ebaf-1b0d-4cb7-994c-43151f6c8e3d clock.PostConditioning.area.total
get_metric -raw -id current -uuid 5263ebaf-1b0d-4cb7-994c-43151f6c8e3d clock.eGRPC.area.total
get_metric -raw -id current -uuid 5263ebaf-1b0d-4cb7-994c-43151f6c8e3d clock.Routing.area.total
get_metric -raw -id current -uuid 5263ebaf-1b0d-4cb7-994c-43151f6c8e3d clock.Implementation.area.total
get_metric -raw -id current -uuid 5263ebaf-1b0d-4cb7-994c-43151f6c8e3d clock.eGRPC.area.total
get_metric -raw -id current -uuid 5263ebaf-1b0d-4cb7-994c-43151f6c8e3d clock.Construction.area.total
get_metric -raw -id current -uuid 5263ebaf-1b0d-4cb7-994c-43151f6c8e3d clock.Implementation.area.total
get_metric -raw -id current -uuid b662aea6-791d-40bd-838b-31829ed0d8ca clock.Routing.area.total
get_metric -raw -id current -uuid b662aea6-791d-40bd-838b-31829ed0d8ca clock.PostConditioning.area.total
get_metric -raw -id current -uuid b662aea6-791d-40bd-838b-31829ed0d8ca clock.eGRPC.area.total
get_metric -raw -id current -uuid b662aea6-791d-40bd-838b-31829ed0d8ca clock.Routing.area.total
get_metric -raw -id current -uuid b662aea6-791d-40bd-838b-31829ed0d8ca clock.Implementation.area.total
get_metric -raw -id current -uuid b662aea6-791d-40bd-838b-31829ed0d8ca clock.eGRPC.area.total
get_metric -raw -id current -uuid b662aea6-791d-40bd-838b-31829ed0d8ca clock.Construction.area.total
get_metric -raw -id current -uuid b662aea6-791d-40bd-838b-31829ed0d8ca clock.Implementation.area.total
get_metric -raw -id current -uuid e6a2c8cb-0f19-46a8-a490-ee97346e4db6 clock.Routing.area.total
get_metric -raw -id current -uuid e6a2c8cb-0f19-46a8-a490-ee97346e4db6 clock.PostConditioning.area.total
get_metric -raw -id current -uuid e6a2c8cb-0f19-46a8-a490-ee97346e4db6 clock.eGRPC.area.total
get_metric -raw -id current -uuid e6a2c8cb-0f19-46a8-a490-ee97346e4db6 clock.Routing.area.total
get_metric -raw -id current -uuid e6a2c8cb-0f19-46a8-a490-ee97346e4db6 clock.Implementation.area.total
get_metric -raw -id current -uuid e6a2c8cb-0f19-46a8-a490-ee97346e4db6 clock.eGRPC.area.total
get_metric -raw -id current -uuid e6a2c8cb-0f19-46a8-a490-ee97346e4db6 clock.Construction.area.total
get_metric -raw -id current -uuid e6a2c8cb-0f19-46a8-a490-ee97346e4db6 clock.Implementation.area.total
get_metric -raw -id current -uuid 717a6d6d-123e-408a-b8f5-0670eb8cedcb clock.Routing.area.total
get_metric -raw -id current -uuid 717a6d6d-123e-408a-b8f5-0670eb8cedcb clock.PostConditioning.area.total
get_metric -raw -id current -uuid 717a6d6d-123e-408a-b8f5-0670eb8cedcb clock.eGRPC.area.total
get_metric -raw -id current -uuid 717a6d6d-123e-408a-b8f5-0670eb8cedcb clock.Routing.area.total
get_metric -raw -id current -uuid 717a6d6d-123e-408a-b8f5-0670eb8cedcb clock.Implementation.area.total
get_metric -raw -id current -uuid 717a6d6d-123e-408a-b8f5-0670eb8cedcb clock.eGRPC.area.total
get_metric -raw -id current -uuid 717a6d6d-123e-408a-b8f5-0670eb8cedcb clock.Construction.area.total
get_metric -raw -id current -uuid 717a6d6d-123e-408a-b8f5-0670eb8cedcb clock.Implementation.area.total
get_metric -raw -id current -uuid 7be84df9-39d3-4170-9f4d-69ee7613f2a3 clock.Routing.area.total
get_metric -raw -id current -uuid 7be84df9-39d3-4170-9f4d-69ee7613f2a3 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 7be84df9-39d3-4170-9f4d-69ee7613f2a3 clock.eGRPC.area.total
get_metric -raw -id current -uuid 7be84df9-39d3-4170-9f4d-69ee7613f2a3 clock.Routing.area.total
get_metric -raw -id current -uuid 7be84df9-39d3-4170-9f4d-69ee7613f2a3 clock.Implementation.area.total
get_metric -raw -id current -uuid 7be84df9-39d3-4170-9f4d-69ee7613f2a3 clock.eGRPC.area.total
get_metric -raw -id current -uuid 7be84df9-39d3-4170-9f4d-69ee7613f2a3 clock.Construction.area.total
get_metric -raw -id current -uuid 7be84df9-39d3-4170-9f4d-69ee7613f2a3 clock.Implementation.area.total
get_metric -raw -id current -uuid c63f16b7-37fd-4736-97e3-754cc5324f0f clock.Routing.area.total
get_metric -raw -id current -uuid c63f16b7-37fd-4736-97e3-754cc5324f0f clock.PostConditioning.area.total
get_metric -raw -id current -uuid c63f16b7-37fd-4736-97e3-754cc5324f0f clock.eGRPC.area.total
get_metric -raw -id current -uuid c63f16b7-37fd-4736-97e3-754cc5324f0f clock.Routing.area.total
get_metric -raw -id current -uuid c63f16b7-37fd-4736-97e3-754cc5324f0f clock.Implementation.area.total
get_metric -raw -id current -uuid c63f16b7-37fd-4736-97e3-754cc5324f0f clock.eGRPC.area.total
get_metric -raw -id current -uuid c63f16b7-37fd-4736-97e3-754cc5324f0f clock.Construction.area.total
get_metric -raw -id current -uuid c63f16b7-37fd-4736-97e3-754cc5324f0f clock.Implementation.area.total
get_metric -raw -id current -uuid ac338fe8-9835-4e3c-a201-6c0eae92eb77 clock.Routing.area.total
get_metric -raw -id current -uuid ac338fe8-9835-4e3c-a201-6c0eae92eb77 clock.PostConditioning.area.total
get_metric -raw -id current -uuid ac338fe8-9835-4e3c-a201-6c0eae92eb77 clock.eGRPC.area.total
get_metric -raw -id current -uuid ac338fe8-9835-4e3c-a201-6c0eae92eb77 clock.Routing.area.total
get_metric -raw -id current -uuid ac338fe8-9835-4e3c-a201-6c0eae92eb77 clock.Implementation.area.total
get_metric -raw -id current -uuid ac338fe8-9835-4e3c-a201-6c0eae92eb77 clock.eGRPC.area.total
get_metric -raw -id current -uuid ac338fe8-9835-4e3c-a201-6c0eae92eb77 clock.Construction.area.total
get_metric -raw -id current -uuid ac338fe8-9835-4e3c-a201-6c0eae92eb77 clock.Implementation.area.total
get_metric -raw -id current -uuid 74c2c55a-06ed-449a-a3b4-d5ea6e6c0ca9 clock.Routing.area.total
get_metric -raw -id current -uuid 74c2c55a-06ed-449a-a3b4-d5ea6e6c0ca9 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 74c2c55a-06ed-449a-a3b4-d5ea6e6c0ca9 clock.eGRPC.area.total
get_metric -raw -id current -uuid 74c2c55a-06ed-449a-a3b4-d5ea6e6c0ca9 clock.Routing.area.total
get_metric -raw -id current -uuid 74c2c55a-06ed-449a-a3b4-d5ea6e6c0ca9 clock.Implementation.area.total
get_metric -raw -id current -uuid 74c2c55a-06ed-449a-a3b4-d5ea6e6c0ca9 clock.eGRPC.area.total
get_metric -raw -id current -uuid 74c2c55a-06ed-449a-a3b4-d5ea6e6c0ca9 clock.Construction.area.total
get_metric -raw -id current -uuid 74c2c55a-06ed-449a-a3b4-d5ea6e6c0ca9 clock.Implementation.area.total
get_metric -raw -id current -uuid cf3ebded-4960-4eb7-8e2a-2da590942fe3 clock.Routing.area.total
get_metric -raw -id current -uuid cf3ebded-4960-4eb7-8e2a-2da590942fe3 clock.PostConditioning.area.total
get_metric -raw -id current -uuid cf3ebded-4960-4eb7-8e2a-2da590942fe3 clock.eGRPC.area.total
get_metric -raw -id current -uuid cf3ebded-4960-4eb7-8e2a-2da590942fe3 clock.Routing.area.total
get_metric -raw -id current -uuid cf3ebded-4960-4eb7-8e2a-2da590942fe3 clock.Implementation.area.total
get_metric -raw -id current -uuid cf3ebded-4960-4eb7-8e2a-2da590942fe3 clock.eGRPC.area.total
get_metric -raw -id current -uuid cf3ebded-4960-4eb7-8e2a-2da590942fe3 clock.Construction.area.total
get_metric -raw -id current -uuid cf3ebded-4960-4eb7-8e2a-2da590942fe3 clock.Implementation.area.total
get_metric -raw -id current -uuid ee05eed0-9f20-4135-af53-d3bd97f867f1 clock.Routing.area.total
get_metric -raw -id current -uuid ee05eed0-9f20-4135-af53-d3bd97f867f1 clock.PostConditioning.area.total
get_metric -raw -id current -uuid ee05eed0-9f20-4135-af53-d3bd97f867f1 clock.eGRPC.area.total
get_metric -raw -id current -uuid ee05eed0-9f20-4135-af53-d3bd97f867f1 clock.Routing.area.total
get_metric -raw -id current -uuid ee05eed0-9f20-4135-af53-d3bd97f867f1 clock.Implementation.area.total
get_metric -raw -id current -uuid ee05eed0-9f20-4135-af53-d3bd97f867f1 clock.eGRPC.area.total
get_metric -raw -id current -uuid ee05eed0-9f20-4135-af53-d3bd97f867f1 clock.Construction.area.total
get_metric -raw -id current -uuid ee05eed0-9f20-4135-af53-d3bd97f867f1 clock.Implementation.area.total
get_metric -raw -id current -uuid 720b803b-4c1f-4926-9087-9d323e70a841 clock.Routing.area.total
get_metric -raw -id current -uuid 720b803b-4c1f-4926-9087-9d323e70a841 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 720b803b-4c1f-4926-9087-9d323e70a841 clock.eGRPC.area.total
get_metric -raw -id current -uuid 720b803b-4c1f-4926-9087-9d323e70a841 clock.Routing.area.total
get_metric -raw -id current -uuid 720b803b-4c1f-4926-9087-9d323e70a841 clock.Implementation.area.total
get_metric -raw -id current -uuid 720b803b-4c1f-4926-9087-9d323e70a841 clock.eGRPC.area.total
get_metric -raw -id current -uuid 720b803b-4c1f-4926-9087-9d323e70a841 clock.Construction.area.total
get_metric -raw -id current -uuid 720b803b-4c1f-4926-9087-9d323e70a841 clock.Implementation.area.total
get_metric -raw -id current -uuid 8ed4d931-713f-488f-ad0d-3519640c0617 clock.Routing.area.total
get_metric -raw -id current -uuid 8ed4d931-713f-488f-ad0d-3519640c0617 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 8ed4d931-713f-488f-ad0d-3519640c0617 clock.eGRPC.area.total
get_metric -raw -id current -uuid 8ed4d931-713f-488f-ad0d-3519640c0617 clock.Routing.area.total
get_metric -raw -id current -uuid 8ed4d931-713f-488f-ad0d-3519640c0617 clock.Implementation.area.total
get_metric -raw -id current -uuid 8ed4d931-713f-488f-ad0d-3519640c0617 clock.eGRPC.area.total
get_metric -raw -id current -uuid 8ed4d931-713f-488f-ad0d-3519640c0617 clock.Construction.area.total
get_metric -raw -id current -uuid 8ed4d931-713f-488f-ad0d-3519640c0617 clock.Implementation.area.total
get_metric -raw -id current -uuid 32df3c5a-ccff-4c1a-a3bc-59b559fc938a clock.Routing.area.total
get_metric -raw -id current -uuid 32df3c5a-ccff-4c1a-a3bc-59b559fc938a clock.PostConditioning.area.total
get_metric -raw -id current -uuid 32df3c5a-ccff-4c1a-a3bc-59b559fc938a clock.eGRPC.area.total
get_metric -raw -id current -uuid 32df3c5a-ccff-4c1a-a3bc-59b559fc938a clock.Routing.area.total
get_metric -raw -id current -uuid 32df3c5a-ccff-4c1a-a3bc-59b559fc938a clock.Implementation.area.total
get_metric -raw -id current -uuid 32df3c5a-ccff-4c1a-a3bc-59b559fc938a clock.eGRPC.area.total
get_metric -raw -id current -uuid 32df3c5a-ccff-4c1a-a3bc-59b559fc938a clock.Construction.area.total
get_metric -raw -id current -uuid 32df3c5a-ccff-4c1a-a3bc-59b559fc938a clock.Implementation.area.total
get_metric -raw -id current -uuid 1c61d19c-5657-4c5e-b402-993c605da81b clock.Routing.area.total
get_metric -raw -id current -uuid 1c61d19c-5657-4c5e-b402-993c605da81b clock.PostConditioning.area.total
get_metric -raw -id current -uuid 1c61d19c-5657-4c5e-b402-993c605da81b clock.eGRPC.area.total
get_metric -raw -id current -uuid 1c61d19c-5657-4c5e-b402-993c605da81b clock.Routing.area.total
get_metric -raw -id current -uuid 1c61d19c-5657-4c5e-b402-993c605da81b clock.Implementation.area.total
get_metric -raw -id current -uuid 1c61d19c-5657-4c5e-b402-993c605da81b clock.eGRPC.area.total
get_metric -raw -id current -uuid 1c61d19c-5657-4c5e-b402-993c605da81b clock.Construction.area.total
get_metric -raw -id current -uuid 1c61d19c-5657-4c5e-b402-993c605da81b clock.Implementation.area.total
get_metric -raw -id current -uuid 26c9f519-1080-4124-a3ce-52d4a565b000 clock.Routing.area.total
get_metric -raw -id current -uuid 26c9f519-1080-4124-a3ce-52d4a565b000 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 26c9f519-1080-4124-a3ce-52d4a565b000 clock.eGRPC.area.total
get_metric -raw -id current -uuid 26c9f519-1080-4124-a3ce-52d4a565b000 clock.Routing.area.total
get_metric -raw -id current -uuid 26c9f519-1080-4124-a3ce-52d4a565b000 clock.Implementation.area.total
get_metric -raw -id current -uuid 26c9f519-1080-4124-a3ce-52d4a565b000 clock.eGRPC.area.total
get_metric -raw -id current -uuid 26c9f519-1080-4124-a3ce-52d4a565b000 clock.Construction.area.total
get_metric -raw -id current -uuid 26c9f519-1080-4124-a3ce-52d4a565b000 clock.Implementation.area.total
get_metric -raw -id current -uuid a0ea779c-759f-433a-b1eb-bd688ad89c08 clock.Routing.area.total
get_metric -raw -id current -uuid a0ea779c-759f-433a-b1eb-bd688ad89c08 clock.PostConditioning.area.total
get_metric -raw -id current -uuid a0ea779c-759f-433a-b1eb-bd688ad89c08 clock.eGRPC.area.total
get_metric -raw -id current -uuid a0ea779c-759f-433a-b1eb-bd688ad89c08 clock.Routing.area.total
get_metric -raw -id current -uuid a0ea779c-759f-433a-b1eb-bd688ad89c08 clock.Implementation.area.total
get_metric -raw -id current -uuid a0ea779c-759f-433a-b1eb-bd688ad89c08 clock.eGRPC.area.total
get_metric -raw -id current -uuid a0ea779c-759f-433a-b1eb-bd688ad89c08 clock.Construction.area.total
get_metric -raw -id current -uuid a0ea779c-759f-433a-b1eb-bd688ad89c08 clock.Implementation.area.total
get_metric -raw -id current -uuid 38c1d34b-6726-4d2e-be93-5d22c5607255 clock.Routing.area.total
get_metric -raw -id current -uuid 38c1d34b-6726-4d2e-be93-5d22c5607255 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 38c1d34b-6726-4d2e-be93-5d22c5607255 clock.eGRPC.area.total
get_metric -raw -id current -uuid 38c1d34b-6726-4d2e-be93-5d22c5607255 clock.Routing.area.total
get_metric -raw -id current -uuid 38c1d34b-6726-4d2e-be93-5d22c5607255 clock.Implementation.area.total
get_metric -raw -id current -uuid 38c1d34b-6726-4d2e-be93-5d22c5607255 clock.eGRPC.area.total
get_metric -raw -id current -uuid 38c1d34b-6726-4d2e-be93-5d22c5607255 clock.Construction.area.total
get_metric -raw -id current -uuid 38c1d34b-6726-4d2e-be93-5d22c5607255 clock.Implementation.area.total
get_metric -raw -id current -uuid d3c78776-db64-4162-ab3c-becd86a5bd9a clock.Routing.area.total
get_metric -raw -id current -uuid d3c78776-db64-4162-ab3c-becd86a5bd9a clock.PostConditioning.area.total
get_metric -raw -id current -uuid d3c78776-db64-4162-ab3c-becd86a5bd9a clock.eGRPC.area.total
get_metric -raw -id current -uuid d3c78776-db64-4162-ab3c-becd86a5bd9a clock.Routing.area.total
get_metric -raw -id current -uuid d3c78776-db64-4162-ab3c-becd86a5bd9a clock.Implementation.area.total
get_metric -raw -id current -uuid d3c78776-db64-4162-ab3c-becd86a5bd9a clock.eGRPC.area.total
get_metric -raw -id current -uuid d3c78776-db64-4162-ab3c-becd86a5bd9a clock.Construction.area.total
get_metric -raw -id current -uuid d3c78776-db64-4162-ab3c-becd86a5bd9a clock.Implementation.area.total
get_metric -raw -id current -uuid b37ade29-8c72-4ffb-a70d-dc19182e5fd5 clock.Routing.area.total
get_metric -raw -id current -uuid b37ade29-8c72-4ffb-a70d-dc19182e5fd5 clock.PostConditioning.area.total
get_metric -raw -id current -uuid b37ade29-8c72-4ffb-a70d-dc19182e5fd5 clock.eGRPC.area.total
get_metric -raw -id current -uuid b37ade29-8c72-4ffb-a70d-dc19182e5fd5 clock.Routing.area.total
get_metric -raw -id current -uuid b37ade29-8c72-4ffb-a70d-dc19182e5fd5 clock.Implementation.area.total
get_metric -raw -id current -uuid b37ade29-8c72-4ffb-a70d-dc19182e5fd5 clock.eGRPC.area.total
get_metric -raw -id current -uuid b37ade29-8c72-4ffb-a70d-dc19182e5fd5 clock.Construction.area.total
get_metric -raw -id current -uuid b37ade29-8c72-4ffb-a70d-dc19182e5fd5 clock.Implementation.area.total
get_metric -raw -id current -uuid a5c295bd-36e7-4a6c-a389-bf27201e6438 clock.Routing.area.total
get_metric -raw -id current -uuid a5c295bd-36e7-4a6c-a389-bf27201e6438 clock.PostConditioning.area.total
get_metric -raw -id current -uuid a5c295bd-36e7-4a6c-a389-bf27201e6438 clock.eGRPC.area.total
get_metric -raw -id current -uuid a5c295bd-36e7-4a6c-a389-bf27201e6438 clock.Routing.area.total
get_metric -raw -id current -uuid a5c295bd-36e7-4a6c-a389-bf27201e6438 clock.Implementation.area.total
get_metric -raw -id current -uuid a5c295bd-36e7-4a6c-a389-bf27201e6438 clock.eGRPC.area.total
get_metric -raw -id current -uuid a5c295bd-36e7-4a6c-a389-bf27201e6438 clock.Construction.area.total
get_metric -raw -id current -uuid a5c295bd-36e7-4a6c-a389-bf27201e6438 clock.Implementation.area.total
get_metric -raw -id current -uuid cf3c2607-f50b-4d69-9d11-419fddc9bc05 clock.Routing.area.total
get_metric -raw -id current -uuid cf3c2607-f50b-4d69-9d11-419fddc9bc05 clock.PostConditioning.area.total
get_metric -raw -id current -uuid cf3c2607-f50b-4d69-9d11-419fddc9bc05 clock.eGRPC.area.total
get_metric -raw -id current -uuid cf3c2607-f50b-4d69-9d11-419fddc9bc05 clock.Routing.area.total
get_metric -raw -id current -uuid cf3c2607-f50b-4d69-9d11-419fddc9bc05 clock.Implementation.area.total
get_metric -raw -id current -uuid cf3c2607-f50b-4d69-9d11-419fddc9bc05 clock.eGRPC.area.total
get_metric -raw -id current -uuid cf3c2607-f50b-4d69-9d11-419fddc9bc05 clock.Construction.area.total
get_metric -raw -id current -uuid cf3c2607-f50b-4d69-9d11-419fddc9bc05 clock.Implementation.area.total
get_metric -raw -id current -uuid 2d1cb1f0-56c0-46d2-9e2f-45e3225805f3 clock.Routing.area.total
get_metric -raw -id current -uuid 2d1cb1f0-56c0-46d2-9e2f-45e3225805f3 clock.PostConditioning.area.total
get_metric -raw -id current -uuid 2d1cb1f0-56c0-46d2-9e2f-45e3225805f3 clock.eGRPC.area.total
get_metric -raw -id current -uuid 2d1cb1f0-56c0-46d2-9e2f-45e3225805f3 clock.Routing.area.total
get_metric -raw -id current -uuid 2d1cb1f0-56c0-46d2-9e2f-45e3225805f3 clock.Implementation.area.total
get_metric -raw -id current -uuid 2d1cb1f0-56c0-46d2-9e2f-45e3225805f3 clock.eGRPC.area.total
get_metric -raw -id current -uuid 2d1cb1f0-56c0-46d2-9e2f-45e3225805f3 clock.Construction.area.total
get_metric -raw -id current -uuid 2d1cb1f0-56c0-46d2-9e2f-45e3225805f3 clock.Implementation.area.total
get_metric -raw -id current -uuid 315347be-2eb9-4f94-8daa-24cbaa4f2a9c clock.Routing.area.total
get_metric -raw -id current -uuid 315347be-2eb9-4f94-8daa-24cbaa4f2a9c clock.PostConditioning.area.total
get_metric -raw -id current -uuid 315347be-2eb9-4f94-8daa-24cbaa4f2a9c clock.eGRPC.area.total
get_metric -raw -id current -uuid 315347be-2eb9-4f94-8daa-24cbaa4f2a9c clock.Routing.area.total
get_metric -raw -id current -uuid 315347be-2eb9-4f94-8daa-24cbaa4f2a9c clock.Implementation.area.total
get_metric -raw -id current -uuid 315347be-2eb9-4f94-8daa-24cbaa4f2a9c clock.eGRPC.area.total
get_metric -raw -id current -uuid 315347be-2eb9-4f94-8daa-24cbaa4f2a9c clock.Construction.area.total
get_metric -raw -id current -uuid 315347be-2eb9-4f94-8daa-24cbaa4f2a9c clock.Implementation.area.total
write_sdf $vars(results_dir)/$vars(design).sdf
writeTimingCon results/Conv.pt.sdc
saveNetlist -excludeLeafCell -phys -excludeCellInst {FILLCELL_X32 FILLCELL_X16 FILLCELL_X8 FILLCELL_X4 FILLCELL_X2 FILLCELL_X1 WELLTAP_X1 } results/Conv.lvs.v
saveNetlist -excludeLeafCell -phys -excludeCellInst {FILLCELL_X32 FILLCELL_X16 FILLCELL_X8 FILLCELL_X4 FILLCELL_X2 FILLCELL_X1 WELLTAP_X1 } results/Conv.virtuoso.v
saveNetlist -excludeLeafCell results/Conv.vcs.v
write_lef_abstract -specifyTopLayer 7 -PGPinLayers {8 9} -noCutObs -stripePin results/Conv.lef
defOut results/Conv.def.gz
report_area -verbose > reports/signoff.area.rpt
getVersion
saveDesign checkpoints/design.checkpoint/save.enc -user_path
