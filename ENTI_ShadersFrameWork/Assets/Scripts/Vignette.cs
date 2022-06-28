
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

//Needed to let unity serialize this and extend PostProcessEffectSettings
[Serializable]
//Using [PostProcess()] attrib allows us to tell Unity that the class holds postproccessing data. 
[PostProcess(renderer: typeof(VignetteRenderer),//First parameter links settings with actual renderer
            PostProcessEvent.AfterStack,//Tells Unity when to execute this postpro in the stack
            "Custom/Vignette")] //Creates a menu entry for the effect
                                //Forth parameter that allows to decide if the effect should be shown in scene view

public sealed class Vignette : PostProcessEffectSettings
{//Custom parameter class, full list at: /PostProcessing/Runtime/
 //The default value is important, since is the one that will be used for blending if only 1 of volume has this effect
    [Range(0f, 1f), Tooltip("Effect Intensity.")]
    public FloatParameter blend = new FloatParameter { value = 0.0f };

    [Tooltip("Color a teñir.")]
    public ColorParameter color = new ColorParameter { value = Color.white };

    [Range(0f, 1f), Tooltip("Effect Intensity.")]
    public FloatParameter _innerRadius = new FloatParameter { value = 0.0f };
    [Range(0f, 1f), Tooltip("Effect Intensity.")]
    public FloatParameter _outerRadius = new FloatParameter { value = 0.0f };


}

public class VignetteRenderer : PostProcessEffectRenderer<Vignette>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Vignette"));

        //Set the uniform value for our shader
        sheet.properties.SetFloat("_intensity", settings.blend);
        sheet.properties.SetColor("_color", settings.color);
        sheet.properties.SetFloat("_innerRadius", settings._innerRadius);
        sheet.properties.SetFloat("_outerRadius", settings._outerRadius);

        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}