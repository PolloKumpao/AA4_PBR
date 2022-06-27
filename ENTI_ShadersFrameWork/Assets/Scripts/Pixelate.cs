using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

//Needed to let unity serialize this and extend PostProcessEffectSettings
[Serializable]
//Using [PostProcess()] attrib allows us to tell Unity that the class holds postproccessing data. 
[PostProcess(renderer: typeof(PixelateRenderer),//First parameter links settings with actual renderer
            PostProcessEvent.AfterStack,//Tells Unity when to execute this postpro in the stack
            "Custom/Pixelate")] //Creates a menu entry for the effect
                                    //Forth parameter that allows to decide if the effect should be shown in scene view

public sealed class Pixelate : PostProcessEffectSettings
{
    [Range(0f, 500), Tooltip("Effect Intensity.")]
    public IntParameter NPixels = new IntParameter { value = 30}; //Custom parameter class, full list at: /PostProcessing/Runtime/
                                                                        //The default value is important, since is the one that will be used for blending if only 1 of volume has this effect
}

public class PixelateRenderer : PostProcessEffectRenderer<Pixelate>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Pixelate"));

        //Set the uniform value for our shader
        sheet.properties.SetFloat("_pixelSize", settings.NPixels);

        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}

