/*******************************************************************************
 * Copyright (c) 2019, 2019 IBM Corporation and others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/

package com.kruize.environment;

import com.kruize.exceptions.MonitoringAgentNotSupportedException;
import com.kruize.exceptions.env.ClusterTypeNotSupportedException;
import com.kruize.exceptions.env.K8sTypeNotSupportedException;
import com.kruize.util.HttpUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.MalformedURLException;
import java.net.URL;

public class DeploymentInfo
{
    private static String clusterType = "kubernetes";
    private static String kubernetesType = "ICP";
    private static String authType = "OIDC";
    private static String authToken;
    private static String monitoringAgent = "prometheus";
    private static String monitoringAgentService = "prometheus-k8s";
    private static String monitoringAgentEndpoint = "";
    private static boolean monitoringAgentRunning = false;

    private static final Logger LOGGER = LoggerFactory.getLogger(DeploymentInfo.class);


    public static String getMonitoringAgentEndpoint()
    {
        return monitoringAgentEndpoint;
    }

    public static void setMonitoringAgentEndpoint(String monitoringAgentEndpoint)
    {
        if (monitoringAgentEndpoint.endsWith("/")) {
            DeploymentInfo.monitoringAgentEndpoint =
                    monitoringAgentEndpoint.substring(0, monitoringAgentEndpoint.length() - 1);
        } else {
            DeploymentInfo.monitoringAgentEndpoint = monitoringAgentEndpoint;
        }
    }

    public static String getClusterType()
    {
        return clusterType;
    }

    public static void setClusterType(String clusterType) throws ClusterTypeNotSupportedException
    {
        if (clusterType != null)
            clusterType = clusterType.toUpperCase();

        if (SupportedTypes.CLUSTER_TYPES_SUPPORTED.contains(clusterType)) {
            DeploymentInfo.clusterType = clusterType;
        } else {
            LOGGER.error("Cluster type {} is not supported", clusterType);
            throw new ClusterTypeNotSupportedException();
        }
    }

    public static String getKubernetesType()
    {
        return kubernetesType;
    }

    public static void setKubernetesType(String kubernetesType) throws K8sTypeNotSupportedException
    {
        if (kubernetesType != null)
            kubernetesType = kubernetesType.toUpperCase();

        if (SupportedTypes.K8S_TYPES_SUPPORTED.contains(kubernetesType)) {
            DeploymentInfo.kubernetesType = kubernetesType;
        } else {
            LOGGER.error("k8s type {} is not suppported", kubernetesType);
            throw new K8sTypeNotSupportedException();
        }
    }

    public static String getAuthType()
    {
        return authType;
    }

    public static void setAuthType(String authType)
    {
        if (authType != null)
            authType = authType.toUpperCase();

        if (SupportedTypes.AUTH_TYPES_SUPPORTED.contains(authType)) {
            DeploymentInfo.authType = authType;
        }
    }

    public static String getAuthToken()
    {
        return authToken;
    }

    public static void setAuthToken(String authToken)
    {
        DeploymentInfo.authToken = (authToken == null) ? "" : authToken;
    }

    public static String getMonitoringAgent()
    {
        return monitoringAgent;
    }

    public static void setMonitoringAgent(String monitoringAgent) throws MonitoringAgentNotSupportedException
    {
        if (monitoringAgent != null)
            monitoringAgent = monitoringAgent.toUpperCase();

        if (SupportedTypes.MONITORING_AGENTS_SUPPORTED.contains(monitoringAgent)) {
            DeploymentInfo.monitoringAgent = monitoringAgent;
        } else {
            LOGGER.error("Monitoring agent {}  is not supported", monitoringAgent);
            throw new MonitoringAgentNotSupportedException();
        }
    }

    public static String getMonitoringAgentService()
    {
        return monitoringAgentService;
    }

    public static void setMonitoringAgentService(String monitoringAgentService)
    {
        if (monitoringAgentService != null)
            DeploymentInfo.monitoringAgentService = monitoringAgentService.toUpperCase();
    }

    public static boolean isMonitoringAgentRunning()
    {
        return monitoringAgentRunning;
    }

    public static void checkMonitoringAgentRunning()
    {
        int responseCode = 0;
        if (monitoringAgentEndpoint != "") {
            try {
                responseCode = HttpUtil.getResponseCode(new URL(getMonitoringAgentEndpoint() + "/-/healthy"));
            } catch (MalformedURLException ignored) { }
        }

        if (responseCode == 200)
            DeploymentInfo.monitoringAgentRunning = true;
    }

    public static void logDeploymentInfo()
    {
        LOGGER.info("Cluster Type: {}", getClusterType());
        LOGGER.info("Kubernetes Type: {}", getKubernetesType());
        LOGGER.info("Auth Type: {}", getAuthType());
        LOGGER.info("Monitoring Agent: {}", getMonitoringAgent());
        LOGGER.info("Monitoring Agent URL: {}", getMonitoringAgentEndpoint());
        LOGGER.info("Is Monitoring Agent Running: {}", isMonitoringAgentRunning());
        LOGGER.info("Monitoring agent service: {}\n\n", getMonitoringAgentService());
    }
}
