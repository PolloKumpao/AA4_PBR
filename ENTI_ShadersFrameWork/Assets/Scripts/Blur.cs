using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

//Needed to let unity serialize this and extend PostProcessEffectSettings
[Serializable]
//Using [PostProcess()] attrib allows us to tell Unity that the class holds postproccessing data. 
[PostProcess(renderer: typeof(BlurRenderer),//First parameter links settings with actual renderer
            PostProcessEvent.AfterStack,//Tells Unity when to execute this postpro in the stack
            "Custom/Blur")] //Creates a menu entry for the effect
                            //Forth parameter that allows to decide if the effect should be shown in scene view

public sealed class Blur : PostProcessEffectSettings
{//Custom parameter class, full list at: /PostProcessing/Runtime/
 //The default value is important, since is the one that will be used for blending if only 1 of volume has this effect
    [Range(0f, 0.1f), Tooltip("Effect Intensity.")]
    public FloatParameter blend = new FloatParameter { value = 0.0f };

    [Range(0f, 5f) , Tooltip("Sample amount")]
    public IntParameter sample = new IntParameter { value = 0 };

    [Range(0f, 0.1f), Tooltip("StandarDeviation")]
    public FloatParameter StandarDeviation = new FloatParameter { value = 0.02f };
}

public class BlurRenderer : PostProcessEffectRenderer<Blur>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Blur"));

        //Set the uniform value for our shader
        sheet.properties.SetFloat("_BlurSize", settings.blend);
        sheet.properties.SetInt("_sample", settings.sample);
        sheet.properties.SetFloat("_SD", settings.StandarDeviation);

        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}
